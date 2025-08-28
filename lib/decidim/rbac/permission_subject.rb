# frozen_string_literal: true

module Decidim
  module RBAC
    # Only records that belong to an organization can represent permission
    # subjects. The roles are assigned for subjects on specific records and the
    # default record is the organization itself. If the user has a defined role
    # within the organization, they are able to perform any actions whose
    # permissions have been assigned to those roles.
    #
    # For example, given there is a role named `organization_admin` with the
    # following permissions assigned to that role:
    #   result: # <-- resource type or a specific resource
    #     # Permissions assigned to the role
    #     - create
    #     - create_children
    #     - destroy
    #     - update
    module PermissionSubject
      extend ActiveSupport::Concern

      included do
        has_many :permission_role_assignments, as: :subject, class_name: "Decidim::RBAC::PermissionRoleAssignment", dependent: :destroy
        # has_many :permission_roles, through: :permission_role_assignments
      end

      def permissions_within(records)
        # Check permissions within all these records as the user may have given
        # different roles within these contexts.
        expanded_records = records.flat_map do |record|
          [record,
            (record.respond_to?(:component) ? record.component : nil),
            (record.respond_to?(:participatory_space) ? record.participatory_space : nil),
            (record.respond_to?(:organization) ? record.organization : nil)
          ]
        end

        permission_role_assignments.where(record: expanded_records.compact.uniq).permissions
      end

      def assign_role!(role, resource: nil)
        return if permission_role_assignments.find_by(key: role, resource: resource || organization).present?

        permission_role_assignments.create!(key: role, resource: resource || organization)
      end

      def find_all_record_types(record_types)
        Array(record_types).flat_map do |record_type|
          table = type_to_table(record_type)
          next [] unless table

          permission_role_assignments
            .where(record_type: record_type)
            .where("decidim_rbac_permission_role_assignments.role LIKE ?", "%_admin")
            .joins("INNER JOIN #{table} ON #{table}.id = decidim_rbac_permission_role_assignments.record_id")
            .where("#{table}.decidim_organization_id = ?", current_organization.id)
            .map(&:record)
        end.uniq
      end

      private

      def type_to_table(type)
        candidates = {
          "Decidim::ParticipatoryProcess"      => "decidim_participatory_processes",
          "Decidim::ParticipatoryProcessGroup" => "decidim_participatory_process_groups",
          "Decidim::Assembly"                  => "decidim_assemblies"
        }
        candidates[type]
      end

      def current_organization 
        @current_organization ||= organization
      end
    end
  end
end

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

      def accessible_records(applicable_classes=nil)
        return all_accessible_records unless applicable_classes.present?
        
        Array(applicable_classes).flat_map do |klass|
          next unless class_name_supported?(klass)

          table = klass.constantize&.table_name
          next [] unless table

          roles_scope = permission_role_assignments
                          .where(record_type: klass)
                          .joins("INNER JOIN #{table} ON #{table}.id = decidim_rbac_permission_role_assignments.record_id")
                          .where("#{table}.decidim_organization_id = ?", current_organization.id)
                          .where(
                            "decidim_rbac_permission_role_assignments.role IN (?) OR decidim_rbac_permission_role_assignments.role LIKE ?",
                            privileged_roles, "%_admin"
                          )

          roles_scope.map(&:record)
        end.uniq
      end

      def is_organization_admin?
        permission_role_assignments.exists?(role: "organization_admin", record: organization)
      end

      private

      def class_name_supported?(class_name)
        supported_space_classes.include?(class_name)
      end

      def current_organization 
        @current_organization ||= organization
      end

      def privileged_roles
        @privileged_roles ||= ::Decidim::RBAC.privileged_roles
      end

      def supported_space_classes
        @supported_space_classes ||= ::Decidim::RBAC.supported_space_classes
      end

      def all_accessible_records
        permission_role_assignments.where(
          "decidim_rbac_permission_role_assignments.role IN (?) OR decidim_rbac_permission_role_assignments.role LIKE ?",
          privileged_roles, "%_admin"
        ).map(&:record)
      end
    end
  end
end

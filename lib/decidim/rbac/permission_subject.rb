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

      def permissions_within(record, fallback)
        # Check permissions within extended records if the permission should fallback to organization level
        records = expanded_records(record, fallback)

        permission_role_assignments.where(record: records).or(
          permission_role_assignments.where(record: organization, role: "organization_admin")
        ).permissions
      end

      def expanded_records(record, fallback)
        records = 
        [
          record,
          (record.respond_to?(:component) ? record.component : nil),
          (record.respond_to?(:participatory_space) ? record.participatory_space : nil)
        ]
        records.push(record.organization) if fallback && record.respond_to?(:organization)

        records.compact.uniq
      end

      def assign_role!(role, resource)
        permission_role_assignments.find_or_create_by!(
          role: role,
          record: resource
        )
      end

      def unassign_role!(role, resource)
        assignment = permission_role_assignments.find_by(role: role, record: resource)
          assignment.destroy! if assignment
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

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

      def permissions_within(record)
        # Check permissions within all these records as the user may have given
        # different roles within these contexts.
        records = [record]
        records << record.component if record.respond_to?(:component)
        records << record.participatory_space if record.respond_to?(:participatory_space)
        records << record.organization if record.respond_to?(:organization)

        permission_role_assignments.where(record: records).permissions
      end

      def assign_role!(role, resource: nil)
        return if permission_role_assignments.find_by(key: role, resource: resource || organization).present?

        permission_role_assignments.create!(key: role, resource: resource || organization)
      end
    end
  end
end

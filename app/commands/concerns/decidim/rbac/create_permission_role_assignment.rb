# frozen_string_literal: true 

module Decidim
  module RBAC
    module CreatePermissionRoleAssignment
      def create_permission_role(record, subject, role)
        PermissionRoleAssignment.create(
          record:,
          subject:,
          role:
        )
      end
    end
  end
end
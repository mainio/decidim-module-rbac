# frozen_string_literal: true

module Decidim
  module RBAC
    class PermissionRole < ApplicationRecord
      has_many :assignments, foreign_key: "permission_role_id", class_name: "Decidim::RBAC::PermissionRoleAssignment", dependent: :destroy

      # The permission
      def allows?(permission, operation)
        data = permissions[permission.to_s]
        return false if data.is_a?(Hash)

        data
      end
    end
  end
end

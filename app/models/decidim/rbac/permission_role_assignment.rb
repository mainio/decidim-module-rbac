# frozen_string_literal: true

module Decidim
  module RBAC
    class PermissionRoleAssignment < ApplicationRecord
      belongs_to :record, polymorphic: true
      belongs_to :subject, polymorphic: true, optional: true

      def self.roles
        pluck(:role)
      end

      def self.permissions
        return {} if roles.empty?

        role_permissions = Decidim::RBAC.registry.roles(*roles)
        role_permissions.inject({}) do |result, role|
          result.deep_merge(role.permissions)
        end
      end
    end
  end
end

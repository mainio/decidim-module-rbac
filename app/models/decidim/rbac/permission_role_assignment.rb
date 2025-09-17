# frozen_string_literal: true

module Decidim
  module RBAC
    class PermissionRoleAssignment < ApplicationRecord
      belongs_to :record, polymorphic: true
      belongs_to :subject, polymorphic: true, optional: true

      def self.roles
        pluck(:role)
      end

      def self.permissions(roles=nil)
        roles ||= self.roles
        return {} if roles.empty?

        role_permissions = Decidim::RBAC.registry.roles(*roles)
        role_permissions.inject({}) do |result, role|
          result.deep_merge(role.permissions) do |_key, old_val, new_val|
            (Array(old_val) + Array(new_val)).compact.uniq
          end
        end
      end
    end
  end
end
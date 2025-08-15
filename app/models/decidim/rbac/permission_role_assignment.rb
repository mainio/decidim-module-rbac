# frozen_string_literal: true

module Decidim
  module RBAC
    class PermissionRoleAssignment < ApplicationRecord
      belongs_to :record, polymorphic: true
      belongs_to :subject, polymorphic: true, optional: true
      # belongs_to :role, class_name: "Decidim::RBAC::PermissionRole", inverse_of: :assignments

      # scope :for_space, ->(participatory_space) { where(conference: participatory_space) }
      # def self.allowed_to?(permission, role)
      #   PermissionRole.where(id: pluck(:id)).any?
      # end

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
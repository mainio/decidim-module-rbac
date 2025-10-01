# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module RBAC
    module RoleAssignmentableResource
      extend ActiveSupport::Concern

      included do
        has_one :permission_assignment,
                class_name: "Decidim::RBAC::PermissionRoleAssignment",
                as: :record,
                dependent: :destroy
      end
    end
  end
end

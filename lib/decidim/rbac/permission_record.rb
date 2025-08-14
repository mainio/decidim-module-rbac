# frozen_string_literal: true

module Decidim
  module RBAC
    # Records that can have roles assigned to them.
    module PermissionRecord
      extend ActiveSupport::Concern

      included do
        has_many :permission_role_assignments, as: :record, dependent: :destroy
        has_many :permission_roles, through: :permission_role_assignments
      end
    end
  end
end

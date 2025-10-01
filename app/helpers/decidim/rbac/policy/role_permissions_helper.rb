# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      module RolePermissionsHelper
        def visible?(resource = record)
          if resource.is_a?(Decidim::Component)
            return false unless visible?(resource.participatory_space)
            return false if !resource.published? && !can_access_unpublished?(resource)

            return true
          end

          return false if resource.private_space? && !can_access_private?(resource)
          return false if !resource.published? && !can_access_unpublished?(resource)

          true
        end

        def visible_publicly?(resource, operation)
          return false if operation.to_s.starts_with?("admin_")

          visible?(resource)
        end

        def able_to_read_publicly?(operation)
          [:read, :admin_read].include?(operation)
        end

        private

        def has_access_role?(resource, extra_roles: [])
          subject.access_roles(resource).any? do |role|
            role.match?(/_admin/) || extra_roles.include?(role)
          end
        end

        def can_access_private?(resource)
          has_access_role?(resource, extra_roles: %w(private_participant))
        end

        def can_access_unpublished?(resource)
          has_access_role?(resource, extra_roles: %w(collaborator))
        end
      end
    end
  end
end

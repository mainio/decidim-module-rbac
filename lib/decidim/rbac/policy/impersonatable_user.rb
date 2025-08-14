# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ImpersonatableUser < Default
        context_reader :user

        def able?(operation)
          return false unless subject

          case operation
          when :admin_index
            true
          when :admin_promote
            return false unless target_user&.managed?

            Decidim::ImpersonationLog.active.where(admin: subject).empty?
          when :admin_impersonate
            return false if target_user.blank?
            # TODO:
            # We should check that the user does not have admin panel access.
            # But this is not the correct way to do it since participants could
            # have multiple participant roles. Instead, we should check if they
            # have access to the admin panel.
            # return false if target_user.permission_role_assignments.roles != ["participant"]
            return false if organization.available_authorization_handlers.empty?

            Decidim::ImpersonationLog.active.where(admin: subject).empty?
          else
            false
          end
        end

        private

        def organization
          subject.organization
        end

        def target_user
          record || user
        end
      end
    end
  end
end

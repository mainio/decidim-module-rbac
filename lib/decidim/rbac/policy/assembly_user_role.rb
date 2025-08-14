# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AssemblyUserRole < Default
        context_reader :user_role, :assembly

        def able?(operation)
          case operation
          when :admin_create
            true
          when :admin_read
            assembly.present?
          when :admin_invite, :admin_update, :admin_destroy
            user_role.present?
          else
            false
          end
        end
      end
    end
  end
end

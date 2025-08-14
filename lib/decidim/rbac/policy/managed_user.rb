# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ManagedUser < Default
        context_reader :organization, :current_organization

        def able?(operation)
          return false unless subject

          case operation
          when :admin_read, :admin_promote
            true
          when :impersonate
            true
          else
            false
          end
        end
      end
    end
  end
end

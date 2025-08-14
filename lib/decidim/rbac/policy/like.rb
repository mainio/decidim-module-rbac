# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Like < Default
        context_reader :current_settings

        def able?(operation)
          case operation
          when :create, :withdraw
            # TODO: Authorization check
            current_settings.likes_enabled && !current_settings.likes_blocked
          else
            false
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Notification < Default
        context_reader :notification

        def able?(operation)
          case operation
          when :read
            true
          when :destroy
            notification&.user == subject
          else
            false
          end
        end

        def allowed?(operation)
          case operation
          when :destroy
            @record ||= notificaiton
          end

          super
        end
      end
    end
  end
end

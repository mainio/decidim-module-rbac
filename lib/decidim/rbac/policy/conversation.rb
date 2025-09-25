# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Conversation < Default
        context_reader :conversation

        def able?(operation)
          return false unless subject.present?

          case operation
          when :list, :create
            true
          when :read, :update
            record&.participating?(subject)
          else
            false
          end
        end

        def allowed?(operation)
          case operation
          when :create
            @record = subject.organization
          end
          
          super
        end
      end
    end
  end
end

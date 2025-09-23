# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Conversation < Default
        context_reader :conversation

        def able?(operation)
          case operation
          when :list
            true
          when :read
            record&.participating?(interlocutor)
          when :create, :update
            record&.accept_user?(interlocutor)
          else
            false
          end
        end

        private

        def interlocutor
          super || subject
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module StartConversationOverrides
      extend ActiveSupport::Concern
      # include Decidim::RBAC::PermissionSubject

      included do
        def call
          return broadcast(:invalid, form.errors.full_messages) if form.invalid?

          if conversation.save
            notify_interlocutors
            assign_conversation_roles(conversation)

            broadcast(:ok, conversation)
          else
            broadcast(:invalid, conversation.errors.full_messages)
          end
        end

        private

        def assign_conversation_roles(conversation)
          conversation.participants.each do |participant|
            participant.assign_role!("conversation_participant", conversation)
          end
        end
      end
    end
  end
end
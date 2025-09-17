# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class CollaborativeDraft < Default
        context_reader :collaborative_draft

        def able?(operation)
          return false unless collaborative_drafts_enabled?

          case operation
          when :react_to_request_access, :publish, :edit
            collaborative_draft&.open?
          when :request_access
            collaborative_draft&.open? && can_request_access_collaborative_draft?
          when :create
            component&.current_settings&.creation_enabled? # TODO: authorization check
          when :withdraw
            collaborative_draft && !collaborative_draft.withdrawn?
          else
            false
          end
        end

        def allowed?(operation)
          case operation 
          when :create
            return true
          end
          @record ||= collaborative_draft

          super
        end

        private

        def collaborative_drafts_enabled?
          component.settings.collaborative_drafts_enabled
        end

        def can_request_access_collaborative_draft?
          return false unless subject.present?

          !collaborative_draft.requesters.include?(subject) &&
          !collaborative_draft.authors.include?(subject)
        end
      end
    end
  end
end

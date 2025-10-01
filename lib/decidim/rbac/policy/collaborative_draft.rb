# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class CollaborativeDraft < Default
        context_reader :collaborative_draft
        # rubocop:disable Metrics/CyclomaticComplexity
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
        # rubocop:enable Metrics/CyclomaticComplexity

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
          return false if subject.blank?

          collaborative_draft.requesters.exclude?(subject) &&
            collaborative_draft.authors.exclude?(subject)
        end
      end
    end
  end
end

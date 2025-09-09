# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class CollaborativeDraft < Default
        context_reader :collaborative_draft

        def able?(operation)
          return false unless collaborative_drafts_enabled?

          case operation
          when :react_to_request_access, :request_access, :publish, :edit
            collaborative_draft&.open?
          when :create
            component&.current_settings&.creation_enabled? # TODO: authorization check
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

        def component
          @component ||= begin
            resource = (within || record)

            if resource.is_a?(::Decidim::Component)
              resource
            elsif resource.respond_to?(:component)
              resource.component
            end
          end
        end
      end
    end
  end
end

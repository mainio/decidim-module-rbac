# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Amendment < Default
        context_reader :component, :current_component, :amendable

        def able?(operation)
          return false unless component
          return false unless component.settings.amendments_enabled

          case operation
          when :create
            component.current_settings.amendment_creation_enabled
          when :accept, :reject
            component.current_settings.amendment_reaction_enabled
          when :promote
            component.current_settings.amendment_promotion_enabled
          when :withdraw
            record&.amender == subject
          else
            false
          end
        end

        def allowed?(operation)
          case operation
          when :reject, :accept
            @record = amendable
          end

          super
        end

        private

        def component
          super || current_component
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Debate < Default
        context_reader :current_settings, :component

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          case operation
          when :create
            # TODO: authorization check
            current_settings&.creation_enabled?
          when :edit
            record.present?
          when :like
            record.present?
          when :close
            record.present?
          when :read, :report, :export, :admin_create, :admin_read, :admin_export
            true
          when :admin_update
            record && !record.closed? && record.official?
          when :admin_close
            record&.official?
          else
            false
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def allowed?(operation)
          case operation
          when :read
            return true if super(:admin_read)

            return true if !record.hidden?
          end

          super
        end

        private

        def component
          @component ||= begin
            if respond_to?(:component)
              component
            elsif record && record.respond_to?(:component)
              record.component
            elsif within.is_a?(Decidim::Component)
              within
            elsif within.respond_to?(:component)
              within.component
            end
          end
        end
      end
    end
  end
end

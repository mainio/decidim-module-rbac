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
            current_settings&.creation_enabled? && component.participatory_space.can_participate?(subject)
          when :read
            !record.hidden?
          when :edit
            record&.editable_by?(subject)
          when :like
            !record.closed?
          when :close
            record&.closeable_by?(subject)
          when :report, :export, :admin_create, :admin_read, :admin_export
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
      end
    end
  end
end

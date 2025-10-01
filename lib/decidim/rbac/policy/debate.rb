# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Debate < Default
        context_reader :current_settings, :component
        # rubocop:disable Metrics/CyclomaticComplexity
        def able?(operation)
          case operation
          when :create
            # TODO: authorization check
            record.current_settings&.creation_enabled?
          when :edit, :like, :close
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
        # rubocop:enable Metrics/CyclomaticComplexity

        def allowed?(operation)
          case operation
          when :read
            return true if super(:admin_read)

            return true unless record.hidden?
          end

          super
        end
      end
    end
  end
end

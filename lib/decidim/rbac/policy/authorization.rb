# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Authorization < Default
        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          return false if subject.blank?

          case operation
          when :admin_index, :admin_create, :admin_update, :admin_destroy
            true
          when :create
            return false if record.blank?

            record.user == subject && not_already_active?
          when :update, :destroy
            return false if record.blank?

            record.user == subject && !record.granted?
          when :renew
            return false if record.blank?

            record.user == subject && record.granted? && record.renewable?
          else
            false
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        private

        def not_already_active?
          Verifications::Authorizations.new(
            organization: subject.organization,
            user: subject,
            name: record.name
          ).none?
        end
      end
    end
  end
end

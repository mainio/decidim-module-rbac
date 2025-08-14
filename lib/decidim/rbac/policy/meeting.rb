# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Meeting < Default
        context_reader :component_settings, :current_component

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          return admin_able?(operation) if operation.start_with?("admin_")

          case operation
          when :join
            # TODO: Authorization check
            record.can_be_joined_by?(subject)
          when :join_waitlist
            # TODO: Authorization check
            record.waitlist_enabled? &&
              !record.has_available_slots? &&
              !record.has_registration_for?(subject)
          when :leave
            record.registrations_enabled?
          when :decline_invitation
            record.registrations_enabled? &&
              record.invites.exists?(user: subject)
          when :create
            return true if initiative_authorship?

            component_settings&.creation_enabled_for_participants? &&
              current_component.participatory_space.can_participate?(subject)
          when :update
            record.authored_by?(subject) && !record.closed?
          when :withdraw
            record.authored_by?(subject) && !record.withdrawn? && !record.past?
          when :close
            record.authored_by?(subject) && record.past?
          when :register
            # TODO: Authorization check
            record.can_register_invitation?(user)
          when :reply_poll
            # TODO: Authorization check
            record.present? && record.poll.present?
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def admin_able?(operation)
          case operation
          when :admin_close, :admin_copy, :admin_export_registrations, :admin_update, :admin_read_invites
            record.present?
          when :admin_invite_attendee
            record.present? && record.registrations_enabled?
          when :admin_validate_registration_code
            record.present? &&
              record.registrations_enabled? &&
              record.component.settings.registration_code_enabled
          when :admin_create
            true
          else
            false
          end
        end

        private

        def initiative_authorship?
          return false unless Decidim.module_installed?("initiatives")

          participatory_space.is_a?(Decidim::Initiative) &&
            participatory_space.has_authorship?(subject)
        end

        def participatory_space
          @participatory_space ||= current_component.participatory_space
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Meeting < Default
        context_reader :meeting

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          case operation
          when :read, :admin_create
            true
          when :join
            # TODO: Authorization check
            meeting.can_be_joined_by?(subject)
          when :join_waitlist
            # TODO: Authorization check
            meeting.waitlist_enabled? &&
              !meeting.has_available_slots? &&
              !meeting.has_registration_for?(subject)
          when :leave
            meeting.registrations_enabled?
          when :decline_invitation
            meeting.registrations_enabled? &&
              meeting.invites.exists?(user: subject)
          when :create
            component&.settings&.creation_enabled_for_participants?
          when :update
            !meeting.closed?
          when :withdraw
            !meeting.withdrawn? && !meeting.past?
          when :close
            meeting.past?
          when :admin_close, :admin_read_invites, :admin_update
            meeting.present?
          when :register
            meeting&.registrations_enabled? && !meeting&.private_meeting?
            # TODO: Authorization check
          when :admin_invite_attendee
            meeting&.registrations_enabled? && !meeting.closed?
          when :reply_poll
            # TODO: Authorization check
            meeting.present? && meeting.poll.present?
          when :admin_validate_registration_code
            meeting.present? &&
              meeting.registrations_enabled? &&
              meeting.component.settings.registration_code_enabled
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def allowed?(operation)
          self.record ||= meeting
          self.fallback = false if participatory_space.private_space?

          case operation
          when :admin_create
            return super
          when :admin_update, :admin_close, :admin_copy, :admin_export_registrations,
            :admin_read_invites, :admin_invite_attendee, :admin_validate_registration_code
            return false unless meeting.official?

            super
          else
            return false unless visible_publicly?(meeting.component, operation)
          end

          super
        end
      end
    end
  end
end

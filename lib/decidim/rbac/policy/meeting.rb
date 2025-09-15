# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Meeting < Default
        context_reader :meeting

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          case operation
          when :read
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
          when :register
            meeting&.registrations_enabled? && !meeting&.private_meeting?
            # TODO: Authorization check
          when :admin_invite_attendee
            meeting&.registrations_enabled? && !meeting.closed?
          when :admin_read_invites
            meeting&.present?
          when :reply_poll
            # TODO: Authorization check
            meeting.present? && meeting.poll.present?
          when :join_waitlist
            meeting && meeting.waitlist_enabled? && !meeting.has_available_slots?
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def allowed?(operation)
          @fallback = false if participatory_space.private_space?

          case operation
          when :read
            # TODO: THESE PEOPLE CAN SEE THE MEETINGS:
            # 1. admins -> No restriction 
            # 2. Those who have a role in the space(i.e process_admin):
            # All meetings in the same space they have the permissions
            # 3. Members of a private space:
            # 4. Users who have registered to a private or hidden meeting
            # They can see those meetings that are not hidden, or if hidden, they are transparent.
            # ** All users(even the admins) in the public scope, can see the meetings that are not passed

            @record = participatory_space
            @fallback = false if participatory_space.private_space?
          else

          end
          super
        end
      end
    end
  end
end

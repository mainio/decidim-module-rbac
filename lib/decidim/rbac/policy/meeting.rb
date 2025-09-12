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

        def allowed?(operation)
          case operation
          when :read
            return true
          end
          super
        end
      end
    end
  end
end

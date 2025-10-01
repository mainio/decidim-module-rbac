# frozen_string_literal: true

module Decidim
  module RBAC
    module NotificationGeneratorForRecipientOverrides
      extend ActiveSupport::Concern

      included do
        def generate
          return unless event_class
          return unless resource
          return unless recipient

          assign_role!
          notification if notification.save!
        end

        def assign_role!
          recipient.assign_role!("notification_owner", notification)
        end
      end
    end
  end
end

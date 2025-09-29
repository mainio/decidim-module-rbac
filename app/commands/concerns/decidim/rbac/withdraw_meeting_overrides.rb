# frozen_string_literal: true 

module Decidim
  module RBAC
    module WithdrawMeetingOverrides
      extend ActiveSupport::Concern

      included do
        transaction do
          change_meeting_state_to_withdrawn
          @current_user.unassign_role!("meeting_author", @meeting)
        end
      end
    end
  end
end

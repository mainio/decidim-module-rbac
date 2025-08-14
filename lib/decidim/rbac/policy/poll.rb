# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Meeting poll
      class Poll < Default
        context_reader :meeting

        def able?(operation)
          return false unless operation == :admin_update

          subject.present? && meeting.present? && meeting.poll.present?
        end
      end
    end
  end
end

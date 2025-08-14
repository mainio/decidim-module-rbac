# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Agenda < Default
        context_reader :meeting

        def able?(operation)
          case operation
          when :admin_create
            meeting.present?
          when :admin_update
            record.present? && meeting.present?
          else
            false
          end
        end
      end
    end
  end
end

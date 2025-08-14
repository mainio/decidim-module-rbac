# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Notification < Default
        def able?(operation)
          case operation
          when :read
            true
          when :destroy
            record&.user == subject
          else
            false
          end
        end
      end
    end
  end
end

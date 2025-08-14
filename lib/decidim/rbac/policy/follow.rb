# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Follow < Default
        def able?(operation)
          return false unless subject

          case operation
          when :create
            true
          when :delete
            return false unless record

            record.user == subject
          else
            false
          end
        end
      end
    end
  end
end

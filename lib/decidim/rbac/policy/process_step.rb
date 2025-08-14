# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessStep < Default
        def able?(operation)
          case operation
          when :read, :create, :reorder
            true
          when :update, :activate, :destroy
            record.present?
          end
        end
      end
    end
  end
end

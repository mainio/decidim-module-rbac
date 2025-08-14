# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessGroup < Default
        def able?(operation)
          case operation
          when :create, :list, :read
            true
          when :update, :destroy
            record.present?
          end
        end
      end
    end
  end
end

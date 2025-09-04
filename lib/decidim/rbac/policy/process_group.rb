# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessGroup < Default
        def able?(operation)
          case operation
          when :create, :list
            true
          when :update, :destroy, :read
            record.present?
          end
        end

        def allowed?(operation) 
          case operation 
          when :list, :read
            return true 
          end

          super
        end
      end
    end
  end
end

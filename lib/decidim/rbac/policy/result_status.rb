# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ResultStatus < Default
        def able?(operation)
          case operation
          when :admin_create
            true
          when :admin_update, :admin_destroy
            record.present?
          else
            false
          end
        end

        private

        def resource_key
          :status
        end
      end
    end
  end
end

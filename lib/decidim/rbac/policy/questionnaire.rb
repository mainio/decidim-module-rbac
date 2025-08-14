# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Questionnaire < Default
        def able?(operation)
          case operation
          when :respond, :admin_create, :admin_update, :admin_preview, :admin_export_responses
            true
          when :admin_destroy
            record.present?
          else
            false
          end
        end
      end
    end
  end
end

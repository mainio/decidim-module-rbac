# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class QuestionnaireResponses < Default
        def able?(operation)
          case operation
          when :admin_index, :admin_show, :admin_export_response
            true
          else
            false
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class QuestionnairePublishResponses < Default
        context_reader :survey

        def able?(operation)
          case operation
          when :admin_index, :admin_update, :admin_destroy
            survey.present?
          else
            false
          end
        end
      end
    end
  end
end

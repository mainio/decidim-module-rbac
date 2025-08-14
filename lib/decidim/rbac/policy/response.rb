# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Meeting response
      class Response < Default
        context_reader :question

        def able?(operation)
          return false unless operation == :create

          question.present? && subject.present? && !question.responded_by?(subject)
        end
      end
    end
  end
end

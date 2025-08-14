# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Meeting question
      class Question < Default
        def able?(operation)
          return false unless operation == :update

          subject.present? && record.present?
        end
      end
    end
  end
end

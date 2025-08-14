# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Budgets order
      class Order < Default
        context_reader :budget, :workflow

        def able?(operation)
          case operation
          when :create
            budget.present? && workflow.vote_allowed?(budget)
          when :export_pdf
            return false unless subject
            return false if record.blank?

            record.user == subject
          when :admin_remind
            true
          else
            false
          end
        end
      end
    end
  end
end

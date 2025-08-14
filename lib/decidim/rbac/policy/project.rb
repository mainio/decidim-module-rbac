# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Budgets project
      class Project < Default
        context_reader :workflow, :budget

        # rubocop:disable Metrics/CyclomaticComplexity
        def able?(operation)
          case operation
          when :admin_create, :admin_manage_trash
            true
          when :admin_update
            resource.present?
          when :admin_soft_delete
            return false unless record.respond_to?(:deleted?)

            !record.deleted?
          when :admin_restore
            return false unless record.respond_to?(:deleted?)

            record.deleted?
          when :vote
            # TODO: Authorization check
            workflow.vote_allowed?(budget)
          when :read, :report
            record&.visible?
          else
            false
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity
      end
    end
  end
end

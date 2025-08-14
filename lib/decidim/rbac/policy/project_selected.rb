# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Budgets project
      #
      # This should be the other way around
      # enforce_permission_to :update_selected, :project
      class ProjectSelected < Default
        def apply(operation)
          operation == :admin_update
        end
      end
    end
  end
end

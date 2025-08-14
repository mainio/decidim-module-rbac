# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Budgets projects
      class Projects < Default
        def able?(operation)
          operation == :admin_import_proposals
        end
      end
    end
  end
end

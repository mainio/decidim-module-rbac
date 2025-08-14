# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Budgets project
      class ProjectTaxonomy < Default
        def able?(operation)
          operation == :admin_update
        end
      end
    end
  end
end

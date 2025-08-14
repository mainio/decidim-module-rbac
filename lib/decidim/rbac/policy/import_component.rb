# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # This is for importing results from the budgets component.
      #
      # Ideally this policy should be renamed but is kept as is for
      # compatibility reasons.
      class ImportComponent < Default
        def able?(operation)
          case operation
          when :admin_create
            defined?(Decidim::Budgets::Project)
          else
            false
          end
        end
      end
    end
  end
end

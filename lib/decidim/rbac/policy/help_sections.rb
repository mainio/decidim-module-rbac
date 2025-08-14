# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class HelpSections < Default
        def able?(operation)
          operation == :admin_update
        end
      end
    end
  end
end

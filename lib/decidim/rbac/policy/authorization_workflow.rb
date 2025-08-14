# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AuthorizationWorkflow < Default
        def able?(operation)
          operation == :admin_index
        end
      end
    end
  end
end

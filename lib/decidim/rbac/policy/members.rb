# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      # Participatory space members (assembly, process, etc.)
      class Members < Default
        def able?(operation)
          operation == :list
        end
      end
    end
  end
end

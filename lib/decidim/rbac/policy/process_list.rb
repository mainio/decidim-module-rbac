# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessList < Default
        def able?(operation)
          operation == :read
        end
      end
    end
  end
end

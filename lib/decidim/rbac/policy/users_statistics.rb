# frozen_string_literal: true

# frozen_string_literal

module Decidim
  module RBAC
    module Policy
      class UsersStatistics < Default
        def able?(operation)
          operation == :admin_read
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AdminDashboard < Default
        def able?(operation)
          operation == :read || operation == :admin_read
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AdminDashboard < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AdminLog < Default
        def able?(operation)
          operation == :admin_read
        end
      end
    end
  end
end

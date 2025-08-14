# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class UserReport < Default
        def able?(operation)
          operation == :create
        end
      end
    end
  end
end

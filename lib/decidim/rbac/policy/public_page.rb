# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class PublicPage < Default
        def able?(operation)
          operation == :read
        end
      end
    end
  end
end

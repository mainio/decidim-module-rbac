# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Geolocation < Default
        def able?(operation)
          operation == :locate
        end
      end
    end
  end
end

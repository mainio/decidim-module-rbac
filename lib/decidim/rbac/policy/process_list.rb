# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessList < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end
      end
    end
  end
end

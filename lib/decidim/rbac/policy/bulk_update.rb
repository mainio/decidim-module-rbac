# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class BulkUpdate < Default
        def able?(operation)
          operation == :admin_create
        end
      end
    end
  end
end

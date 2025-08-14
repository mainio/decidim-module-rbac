# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class EditorImage < Default
        def able?(operation)
          operation == :edit
        end
      end
    end
  end
end

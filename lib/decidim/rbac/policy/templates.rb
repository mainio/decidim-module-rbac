# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Templates < Default
        def able?(operation)
          case operation
          when :admin_index, :admin_read
            true
          else
            false
          end
        end
      end
    end
  end
end

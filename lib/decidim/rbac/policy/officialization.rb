# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Officialization < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create, :admin_destroy
            true
          else
            false
          end
        end
      end
    end
  end
end

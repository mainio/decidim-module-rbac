# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Moderation < Default
        def able?(operation)
          case operation
          when :admin_read, :create
            true
          else
            false
          end
        end
      end
    end
  end
end

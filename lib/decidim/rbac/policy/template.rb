# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Template < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_index, :admin_create, :admin_copy
            true
          when :admin_update, :admin_destroy
            record.present?
          else
            false
          end
        end
      end
    end
  end
end

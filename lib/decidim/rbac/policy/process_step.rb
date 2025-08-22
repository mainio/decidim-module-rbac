# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessStep < Default
        def able?(operation)
          case operation
          when :read, :admin_read, :create, :admin_create, :admin_reorder, :reorder
            true
          when :update, :admin_update, :activate, :admin_activate, :destroy, :admin_destroy
            record.present?
          end
        end
      end
    end
  end
end

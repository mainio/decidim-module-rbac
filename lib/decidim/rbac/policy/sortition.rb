# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Sortition < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create
            true
          when :admin_update
            record.present?
          when :admin_destroy
            record.present? && !record.cancelled?
          else
            false
          end
        end
      end
    end
  end
end

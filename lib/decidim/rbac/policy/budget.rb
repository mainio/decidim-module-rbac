# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Budget < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create, :admin_export, :admin_manage_trash
            true
          when :admin_update
            record.present?
          when :admin_soft_delete
            return false unless record.respond_to?(:deleted?)

            !record.deleted?
          when :admin_restore
            return false unless record.respond_to?(:deleted?)

            record.deleted?
          else
            false
          end
        end
      end
    end
  end
end

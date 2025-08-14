# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Result < Default
        def able?(operation)
          case operation
          when :admin_create
            true
          when :admin_update
            record.present?
          when :admin_create_children
            record.present? && record.parent.blank?
          when :admin_soft_delete
            return false unless record.respond_to?(:deleted?)

            !record.deleted?
          when :admin_restore
            return false unless record.respond_to?(:deleted?)

            record.deleted?
          when :admin_manage_trash
            true
          else
            false
          end
        end
      end
    end
  end
end

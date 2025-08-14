# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class CollaborativeText < Default
        context_reader :document

        def able?(operation)
          case operation
          when :suggest, :rollout
            subject.present?
          when :admin_read, :admin_create, :admin_manage_trash
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

        private

        def record
          super || document
        end
      end
    end
  end
end

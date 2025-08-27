# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Component < Default
        context_reader :share_token

        def able?(operation)
          case operation
          when :read, :admin_read, :admin_create, :admin_reorder, :admin_manage_trash
            true
          when :admin_manage, :admin_update, :admin_publish, :admin_unpublish, :admin_share
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

        def allowed?(operation)
          case operation
          when :read
            return true if record.published?
            return true if user_can_preview_component?
          end

          super
        end

        private

        def user_can_preview_component?
          return false if share_token.blank?

          Decidim::ShareToken.use!(
            token_for: record,
            token: share_token,
            user: subject
          )
        rescue ActiveRecord::RecordNotFound, StandardError
          false
        end
      end
    end
  end
end

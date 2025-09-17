# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Assembly < Default
        context_reader :share_token, :assembly

        def able?(operation)
          return true if operation == :list
          return false if record && !record.is_a?(Decidim::Assembly)

          case operation
          when :admin_read, :admin_create, :admin_import
            true
          when :read, :admin_update, :admin_publish, :admin_export, :admin_copy, :admin_preview
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
            return true if record.published? && public_or_transparent?
            return true if user_can_preview_space?
          end

          super
        end

        def public_or_transparent?
          !record.private_space || record.is_transparent?
        end

        def user_can_preview_space?
          return false if share_token.blank?

          Decidim::ShareToken.use!(token_for: record, token: share_token, user: subject)
        rescue ActiveRecord::RecordNotFound, StandardError
          false
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ParticipatorySpace < Default
        context_reader :share_token, :current_participatory_space

        def able?(operation)
          case operation
          when :read
            # return true if participatory_space.published? && !participatory_space.private_space?
            return true if user_can_preview_space?
            
            @subject.present?
          when :list, :admin_read, :admin_list, :admin_create, :admin_import
            true
          when :admin_preview, :admin_update, :admin_publish
            @record.present?
          when :admin_soft_delete, :admin_destroy
            return false unless record.respond_to?(:deleted?)

            !@record.deleted?
          when :admin_restore
            return false unless record.respond_to?(:deleted?)

            record.deleted?
          else
            false
          end
        end

        def allowed?(operation)
          case operation
          when :list
            @record = accessible_spaces
          when :read
            @record = participatory_space
            @fallback = false if participatory_space.private_space?
          end

          super
        end

        private

        def user_can_preview_space?
          return false if share_token.blank?

          Decidim::ShareToken.use!(token_for: record, token: share_token, user: subject)
        rescue ActiveRecord::RecordNotFound, StandardError
          false
        end

        def accessible_spaces
          subject.accessible_records("Decidim::ParticipatoryProcess")
        end
      end
    end
  end
end

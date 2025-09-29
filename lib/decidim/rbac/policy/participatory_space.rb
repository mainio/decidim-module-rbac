# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ParticipatorySpace < Default
        delegate :supported_space_classes, to: ::Decidim::RBAC
        context_reader :share_token, :current_participatory_space, :trashable_deleted_resource

        def able?(operation)
          # self.fallback = false if participatory_space.private_space?

          case operation
          when :read
            return true if user_can_preview_space?
            
            record.present?
          when :list, :admin_read, :admin_list, :admin_create, :admin_import
            true
          when :admin_preview, :admin_update, :admin_publish
            record.present?
          when :admin_soft_delete, :admin_destroy
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
          when :list
            return true
          when :read
            return true if visible_publicly?(participatory_space, operation)

            self.record = participatory_space if record.blank?
          when :admin_list, :admin_read
            self.record = accessible_spaces if record.blank?
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

        def participatory_space
          @participatory_space ||= current_participatory_space 
          @participatory_space ||= trashable_deleted_resource if trashable_deleted_resource.is_a?(Decidim::ParticipatoryProcess) ||
          @participatory_space ||= super
        end
      end
    end
  end
end

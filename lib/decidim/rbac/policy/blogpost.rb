# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Blogpost < Default
        context_reader :blogpost

        # rubocop:disable Metrics/CyclomaticComplexity
        def able?(operation)
          case operation
          when :admin_update, :admin_destroy
            admin_can_manage?
          when :admin_soft_delete
            return false unless record.respond_to?(:deleted?)
            return false if record.deleted?

            admin_can_manage?
          when :admin_restore
            return false unless record.respond_to?(:deleted?)
            return false unless record.deleted?

            admin_can_manage?
          when :read
            return false if record.hidden?

            record.visible?
          when :create
            can_manage_post?
          when :update, :destroy
            return false if record.blank?

            can_manage_post?
          else
            # :admin_read, :admin_create, :admin_manage_trash
            true
          end
        end

        def allowed?(operation)
          case operation
          when :update, :destroy
            @record ||= blogpost
          end

          super
        end
        # rubocop:enable Metrics/CyclomaticComplexity

        private

        def can_manage_post?
          return false unless component&.participatory_space&.published?
          return false unless component&.published?

          creation_enabled_for_participants?
        end

        def admin_can_manage?
          return false if record.blank?
          return false unless record.author

          case record.author
          when Decidim::User
            record.author == subject
          when Decidim::Organization
            true
          else
            false
          end
        end

        def creation_enabled_for_participants?
          return false if component.blank?

          component.settings&.creation_enabled_for_participants?
        end
      end
    end
  end
end

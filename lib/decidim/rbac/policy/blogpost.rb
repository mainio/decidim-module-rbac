# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Blogpost < Default
        context_reader :current_component, :component_settings

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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
            can_create_post?
          when :update, :destroy
            return false if record.blank?
            return false unless record.author.is_a?(Decidim::User)
            return false unless can_create_post?

            record.author == subject
          else
            # :admin_read, :admin_create, :admin_manage_trash
            true
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        private

        def can_create_post?
          return false unless current_component&.participatory_space&.published?
          return false unless current_component&.published?

          creation_enabled_for_participants? || initiative_authorship?
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
          component_settings&.creation_enabled_for_participants? &&
            current_component&.participatory_space&.can_participate?(subject)
        end

        def initiative_authorship?
          return false unless Decidim.module_installed?("initiatives")
          return false unless subject

          current_component&.participatory_space.is_a?(Decidim::Initiative) &&
            current_component&.participatory_space&.has_authorship?(subject)
        end
      end
    end
  end
end

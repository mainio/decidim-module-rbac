# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # Common logic to work with the permissions system
  module NeedsPermission
    extend ActiveSupport::Concern
    include RegistersPermissions

    included do
      helper_method :allowed_to?, :admin_allowed_to?

      class ::Decidim::ActionForbidden < StandardError
      end

      # rescue_from Decidim::ActionForbidden, with: :user_has_no_permission

      # Handles the case when a user visits a path that is not allowed to them.
      # Redirects the user to the root path and shows a flash message telling
      # them they are not authorized.
      def user_has_no_permission
        flash[:alert] = t("actions.unauthorized", scope: "decidim.core")
        redirect_to(user_has_no_permission_referer || user_has_no_permission_path)
      end

      def user_has_no_permission_referer
        return unless user_signed_in?
        return if request.referer == request.original_url

        request.referer
      end

      def user_has_no_permission_path
        raise NotImplementedError
      end

      def permissions_context
        {
          current_settings: try(:current_settings),
          component_settings: try(:component_settings),
          current_organization: try(:current_organization),
          current_component: try(:current_component),
          share_token: try(:store_share_token)
        }
      end

      def enforce_permission_to(operation, permission, extra_context = {})
        if Rails.env.development?
          Rails.logger.debug "==========="
          Rails.logger.debug [permission_scope, operation, permission, permission_class_chain].map(&:inspect).join("\n")
          Rails.logger.debug "==========="
        end

        raise Decidim::ActionForbidden unless allowed_to?(operation, permission, extra_context)
      end

      # rubocop:disable Metrics/ParameterLists, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def allowed_to?(operation, resource, extra_context = {}, _chain = permission_class_chain, subject = current_user, scope = nil)
        # These are just a way to try to make it work with all the cases that
        # use this method. Ideally, those parts that are not compatible with the
        # API should be rewritten in the future.
        record = extra_context[:record] || extra_context[:resource]
        record ||= extra_context[resource] if resource.is_a?(Symbol)
        record ||= extra_context[:trashable_deleted_resource] if extra_context.has_key?(:trashable_deleted_resource) && [:restore, :soft_delete].include?(operation)

        within = record || try(:current_component) || try(:current_participatory_space) || try(:current_organization)
        policy = RBAC.policy(resource).new(
          record: record,
          subject: subject,
          within: within,
          **permissions_context.merge(extra_context)
        )

        # Ideally in the permission checks, we should already check against the
        # admin operations instead of providing the separate scope.
        if scope == :admin
          policy.apply(:"admin_#{operation}")
        else
          policy.apply(operation.to_sym)
        end
      rescue Decidim::PermissionAction::PermissionNotSetError
        false
      end
      # rubocop:enable Metrics/ParameterLists, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      def admin_allowed_to?(operation, resource, extra_context = {}, chain = permission_class_chain, subject = current_user)
        allowed_to?(operation, resource, extra_context, chain, subject, :admin)
      end

      def permission_class_chain
        raise "Please, make this method return an array of permission classes"
      end

      def permission_scope
        raise "Please, make this method return a symbol"
      end
    end
  end
end

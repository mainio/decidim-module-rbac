# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # Common logic to work with the permissions system
  module NeedsPermission
    extend ActiveSupport::Concern
    include Decidim::RegistersPermissions

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
          current_participatory_space: try(:current_participatory_space),
          share_token: try(:store_share_token)
        }
      end

      def enforce_permission_to(operation, permission, extra_context = {})
        if Rails.env.development?
          Rails.logger.debug "==========="
          Rails.logger.debug [permission_scope, operation, permission, permission_class_chain].map(&:inspect).join("\n")
          Rails.logger.debug "==========="
        end
        
        # allowed_to?(operation, permission, extra_context, permission_class_chain, current_user, permission_scope)
        unless allowed_to?(operation, permission, extra_context, permission_class_chain, current_user, permission_scope)
          record = extra_context[:record] || extra_context[:resource] || extra_context[:commentable] ||extra_context[:reportable]
          record ||= extra_context[permission] if permission.is_a?(Symbol)
          record ||= extra_context[:trashable_deleted_resource] if extra_context.has_key?(:trashable_deleted_resource) && [:restore, :soft_delete, :read].include?(operation)
          within = record || try(:current_component) || try(:current_participatory_space) || try(:current_organization)

          raise Decidim::ActionForbidden,
            "Forbidden: operation=#{operation.inspect}, permission=#{permission.inspect}, \n" \
            "within: #{within&.class&.name} ID: #{within&.id}\n"\
            "record: #{record&.class&.name} ID: #{record&.id}\n"\
            "context=#{extra_context.inspect}, scope=#{permission_scope.inspect}, \n" \
            "policy class #{RBAC.policy(record)}\n" \
            "within: #{try(:current_component) || try(:current_participatory_space) || try(:current_organization)} \n"\
            "user=#{current_user&.id || 'nil'}\n"
        end
        # raise Decidim::ActionForbidden unless allowed_to?(operation, permission, extra_context, permission_class_chain, current_user, permission_scope)
      end

      # rubocop:disable Metrics/ParameterLists, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def allowed_to?(operation, resource, extra_context = {}, _chain = permission_class_chain, subject = current_user, scope = nil)
      # These are just a way to try to make it work with all the cases that
        # use this method. Ideally, those parts that are not compatible with the
        # API should be rewritten in the future.
        record = extra_context[:record] || extra_context[:resource] || extra_context[:commentable] || extra_context[:reportable]
        record ||= extra_context[resource] if resource.is_a?(Symbol)
        record ||= extra_context[:trashable_deleted_resource] if extra_context.has_key?(:trashable_deleted_resource) && [:restore, :soft_delete].include?(operation)
        # Try would not necessarily return the expected result, since some of the methods that are being called are lazier than others
        # (i.e current_participatory_space compared to current organization).
        # within = record || try(:current_component) || try(:current_participatory_space) || try(:current_organization)
        within = record ||
          permissions_context[:current_participatory_process] ||
          permissions_context[:current_component] ||
          permissions_context[:current_participatory_space] ||
          permissions_context[:current_organization]

        policy = RBAC.policy(resource).new(
          record: record,
          subject: subject,
          within: within,
          **permissions_context.merge(extra_context)
        )

        # Ideally in the permission checks, we should already check against the
        # admin operations instead of providing the separate scope.
        if scope == :admin || permission_scope == :admin
          # if policy.class.name == "Decidim::RBAC::Policy::Moderation" && operation == :unhide
            puts "-*-*-*-*-*-*" * 50
            puts "Resource #{resource}"
            puts "admin_#{operation}"
            puts "POLICY #{policy.class.name}"
            puts "WITHIN: #{within&.class&.name} ##{within&.id}"
            puts "record: #{record&.class&.name}"
            puts "subject: #{subject.id}"
            puts policy.apply(:"admin_#{operation}").inspect
            puts "-*-*-*-*-*-*" * 50
          # end
          
          policy.apply(:"admin_#{operation}")
        else
          puts "-*-*-*-*-*-*" * 50
          puts "Resource #{resource}"
          puts "admin_#{operation}"
          puts "POLICY #{policy.class.name}"
          puts "WITHIN: #{within&.class&.name} ##{within&.id}"
          puts "record: #{record&.class&.name}"
          puts "subject: #{subject.id}"
          puts policy.apply(:"admin_#{operation}").inspect
          puts "-*-*-*-*-*-*" * 50
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

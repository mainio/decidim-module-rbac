# frozen_string_literal: true

module Decidim
  module RBAC
    class Role
      attr_reader :key, :permissions

      def initialize(key)
        @key = key
        @permissions = {}
      end

      def name
        I18n.t("#{key}.name", scope: "decidim.roles")
      end

      def description
        I18n.t("#{key}.description", scope: "decidim.roles")
      end

      def add_permissions(permission_set)
        @permissions.deep_merge!(permission_set)
      end
    end
  end
end

# frozen_string_literal: true

require_relative "rbac/version"
require_relative "rbac/engine"

module Decidim
  module RBAC
    autoload :PermissionRecord, "decidim/rbac/permission_record"
    autoload :PermissionSubject, "decidim/rbac/permission_subject"
    autoload :Registry, "decidim/rbac/registry"
    autoload :Scanner, "decidim/rbac/scanner"

    class << self
      delegate :roles, to: :registry
    end

    def self.registry
      Decidim::RBAC::Registry.instance
    end

    def self.define(&block)
      registry.register(&block)
    end

    def self.policy(key)
      registered = registry.policy(key)
      return registered if registered

      autopolicy = "Policy::#{key.to_s.camelize}".safe_constantize
      return autopolicy if autopolicy

      Policy::Default
    end
  end
end

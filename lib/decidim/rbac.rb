# frozen_string_literal: true

require_relative "rbac/version"
require_relative "rbac/engine"

module Decidim
  module RBAC
    autoload :PermissionRecord, "decidim/rbac/permission_record"
    autoload :PermissionSubject, "decidim/rbac/permission_subject"
    autoload :Registry, "decidim/rbac/registry"
    autoload :Scanner, "decidim/rbac/scanner"
    autoload :Role, "decidim/rbac/role"
    autoload :Policy, "decidim/rbac/policy"

    class << self
      delegate :roles, to: :registry
    end

    def self.registry
      Decidim::RBAC::Registry.instance
    end

    def self.define(&)
      registry.register(&)
    end

    def self.policy(key)
      registered = registry.policy(key)
      return registered if registered

      autopolicy = begin
        Policy.const_get(key.to_s.camelize)
      rescue NameError
        nil
      end
      return autopolicy if autopolicy

      Policy::Default
    end
  end
end

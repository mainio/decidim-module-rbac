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
    autoload :NeedsPermission, "decidim/rbac/needs_permission"
    autoload :PermissionLoader, "decidim/rbac/permission_loader"
    autoload :RoleAssignmentableResource, "decidim/rbac/role_assignmentable_resource"

    PRIVILAGED_ROLES = [
      "collaborator",
      "moderator",
      "user_manager",
      "evaluator",
      "private_participant",
      "collaborative_draft_author",
      "conversation_participant",
      "notification_owner",
      "process_groups_admin"
    ].freeze

    SUPPORTED_SPACE_CLASSES = [
      "Decidim::ParticipatoryProcess",
      "Decidim::Assembly",
  ].freeze

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

    def self.privileged_roles
      PRIVILAGED_ROLES
    end

    def self.supported_space_classes 
      SUPPORTED_SPACE_CLASSES
    end
  end
end

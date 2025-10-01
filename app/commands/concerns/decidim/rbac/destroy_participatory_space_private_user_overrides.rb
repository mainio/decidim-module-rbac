# frozen_string_literal: true

# frozen_string_literal:

module Decidim
  module RBAC
    module DestroyParticipatorySpacePrivateUserOverrides
      extend ActiveSupport::Concern

      included do
        def run_after_hooks
          return unless resource

          resource_base = if resource.respond_to?(:privatable_to)
                            resource.privatable_to
                          else
                            resource
                          end
          return unless resource_base

          user = resource.user
          return unless user

          user.unassign_role!("private_participant", resource_base)
        end
      end
    end
  end
end

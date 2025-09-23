# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AdminUser < Default
        context_reader :user

        def able?(operation)
          case operation
          when :admin_read, :admin_create, :admin_block
            # Note that the block action should also check that the blocked user
            # is not the subject (i.e. the current user). But the permission
            # check done in the controller does not provide the user context
            # which is why we allow this operation always.
            true
          when :admin_invite
            record.present?
          when :admin_destroy
            return false if record.blank?

            record != subject
          else
            false
          end
        end

        private

        def record
          super || user
        end
      end
    end
  end
end

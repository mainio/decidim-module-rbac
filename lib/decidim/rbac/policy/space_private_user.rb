# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class SpacePrivateUser < ShareToken
        context_reader :private_user

        def able?(operation)
          case operation
          when :admin_read, :admin_create, :admin_csv_import
            true
          when :admin_update, :admin_edit, :admin_destroy, :admin_invite
            record.present?
          else
            false
          end
        end

        private

        def record
          super || private_user
        end
      end
    end
  end
end

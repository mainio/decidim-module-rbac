# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class User < Default
        context_reader :current_user

        def able?(operation)
          return false unless subject

          case operation
          when :read, :show, :export, :download, :update, :update_profile, :delete
            return false unless current_user
            return false unless subject

            current_user == subject
          else
            # :admin_show_email
            true
          end
        end
      end
    end
  end
end

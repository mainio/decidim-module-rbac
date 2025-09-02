# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class User < Default
        context_reader :current_user, :user

        def able?(operation)
          return false unless subject

          case operation
          when :read, :show, :export, :download, :update, :update_profile, :delete
            return false unless current_user
            return false unless subject

            current_user == subject
          when :admin_show_email
            user.present?
          else
            super
          end
        end

        def allowed?(operation)
          case operation 
          when :admin_show_email
            @record = user
          end

          super
        end
      end
    end
  end
end

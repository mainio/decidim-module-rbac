# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessGroup < Default
        context_reader :process_group

        def able?(operation)
          case operation
          when :admin_create, :list, :admin_list, :read, :admin_read
            true
          when :admin_update, :admin_destroy
            process_group.present?
          else
            false
          end
        end

        def allowed?(operation)
          @record ||= process_group

          case operation
          when :list, :read
            return true
          end

          super
        end
      end
    end
  end
end

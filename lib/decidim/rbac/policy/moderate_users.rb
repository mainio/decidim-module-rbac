# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ModerateUsers < Default
        def able?(operation)
          return false unless record
          return false unless subject

          case operation
          when :admin_destroy, :admin_block
            record != subject
          when :admin_read, :admin_unreport, :admin_index
            true
          else
            false
          end
        end

        def allowed?(_operation)
          return unless subject.present?

          @record ||= subject.organization

          super
        end
      end
    end
  end
end

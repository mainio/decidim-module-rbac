# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ComponentData < Default
        context_reader :component

        def able?(operation)
          case operation
          when :admin_import, :admin_export
            record.present?
          else
            false
          end
        end

        private

        def record
          super || component
        end
      end
    end
  end
end

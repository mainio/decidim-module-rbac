# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessList < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end

        def allowed?(operation)
          case operation
          when :admin_read
            return false unless subject

            @record = subject.accessible_records
          else
            return false
          end

          super
        end
      end
    end
  end
end

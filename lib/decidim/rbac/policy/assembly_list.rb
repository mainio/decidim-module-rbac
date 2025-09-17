# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AssemblyList < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end

        def allowed?(operation)
          @record = subject.accessible_records("Decidim::Assembly")

          super
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AssemblyList < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end

        def allowed?(operation)
          # If the permission owner has permission to see the list for 
          # one of its assemblies,it should have the permission to see the 
          # entire list.
          return  Decidim::RBAC.registry.role(:visitor).permissions unless subject.present?

          @record ||= subject.accessible_records("Decidim::Assembly")

          super
        end
      end
    end
  end
end

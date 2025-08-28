# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProcessList < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end

        def allowed?(operation)
          # If the permission owner has permission to see the list for 
          # one of its processes,it should have the permission to see the 
          # entire list.
          return  Decidim::RBAC.registry.role(:visitor).values unless subject.present?

          @record ||= subject.accessible_records("Decidim::ParticipatoryProcess")

          super
        end
      end
    end
  end
end

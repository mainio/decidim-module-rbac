# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class SpaceArea < Default
        context_reader :space_name

        def able?(operation)
          return false unless subject
          operation == :admin_enter
        end

        def allowed?(_operation)
          # If the user has a process/space inside the organization, that has the 
          # permission to enter as an admin, they should be able to enter the space, 
          # otherwise they should not even be able to enter the space, unless they are 
          # an organization admin.
          @record ||= begin
            space_class = space_classes[space_name]
            subject.accessible_records(space_class) if space_class
          end

          super
        end

        private 

        def space_classes
          {
            assemblies: "Decidim::Assembly",
            processes: "Decidim::ParticipatoryProcess",
            process_groups: "Decidim::ParticipatoryGroupProcess"
          }
        end
      end
    end
  end
end
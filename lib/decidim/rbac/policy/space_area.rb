# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class SpaceArea < Default
        context_reader :space_name

        def able?(operation)
          return false unless subject
          return false unless operation == :admin_enter

          able_to_enter_space?
        end

        private

        def able_to_enter_space?
          permission_roles = subject.permission_role_assignments
          return true if permission_roles.map(&:record_type).include?(space_types[space_name])
          
          # users with admin role on the organization level should also be able to 
          # enter spaces regardless of the space_types, thats why this 
          # check is being added for entering spaces.
          able_to_admin?(permission_roles)
        end

        def space_types
          {
            assemblies: "Decidim::Assembly",
            conferences: "Decidim::Conference",
            initiatives: "Decidim::Initiative",
            processes: "Decidim::ParticipatoryProcess",
            process_groups: "Decidim::ParticipatoryProcessGroup"
          }
        end

        def able_to_admin?(permission_roles)
          resource = record || within
          return unless resource.is_a?(Decidim::Organization)
          
          permission_roles.any?{|assignment| assignment.record == resource && assignment.role == "organization_admin"}
        end
      end
    end
  end
end
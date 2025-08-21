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
          record_types = subject.permission_role_assignments.pluck(:record_type)

          record_types.include?(space_types[space_name])
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
      end
    end
  end
end
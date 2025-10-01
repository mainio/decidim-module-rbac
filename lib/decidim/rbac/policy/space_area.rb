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
          @record = if space_name == :process_groups
                      subject.permission_role_assignments.where(role: "process_groups_admin", record: subject.organization).map(&:record)
                    else
                      space_class = space_classes[space_name]
                      subject.accessible_records(space_class) if space_class
                    end

          super
        end

        private

        def space_classes
          {
            assemblies: "Decidim::Assembly",
            processes: "Decidim::ParticipatoryProcess"
          }
        end
      end
    end
  end
end

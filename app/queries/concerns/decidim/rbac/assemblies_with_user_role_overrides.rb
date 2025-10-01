# frozen_string_literal: true

module Decidim
  module RBAC
    module AssembliesWithUserRoleOverrides
      extend ActiveSupport::Concern

      included do
        def query
          return Assemblies::OrganizationAssemblies.new(user.organization).query if user.organization_admin?

          Assembly.where(id: assembly_ids)
        end

        private

        def assembly_ids
          user.accessible_records("Decidim::Assembly").map(&:id)
        end
      end
    end
  end
end

# frozen_string_literal: true 

module Decidim 
  module RBAC 
    module AssembliesWithUserRoleOverrides
      extend ActiveSupport::Concern

      included do

        def query
          return Assemblies::OrganizationAssemblies.new(user.organization).query if user.is_organization_admin?
          Assembly.where(id: assembly_ids)
        end

        private 

        def assembly_ids
          raise user.find_all_record_types("Decidim::Assembly").map(&:id).inspect
        end
      end
    end
  end
end
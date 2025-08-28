# frozen_string_literal: true 

module Decidim 
  module RBAC 
    module ParticipatoryProcessesWithUserRoleOverrides
      extend ActiveSupport::Concern

      included do

        def query
          return ParticipatoryProcesses::OrganizationParticipatoryProcesses.new(user.organization).query if user.is_organization_admin?
          ParticipatoryProcess.where(id: process_ids)
        end

        private 

        def process_ids
          user.accessible_records("Decidim::ParticipatoryProcess").map(&:id)
        end
      end
    end
  end
end
# frozen_string_literal: true

module Decidim
  module RBAC
    module ParticipatoryProcessesWithUserRoleOverrides
      extend ActiveSupport::Concern

      included do
        def query
          return ParticipatoryProcesses::OrganizationParticipatoryProcesses.new(user.organization).query if user.organization_admin?
          # In case the admin user has process_groups admin, they should be able to enter the admin area.
          # Currently, the only way to make the users with role of :procees_group_admin to be able to log into
          # the admin area is this.
          return Decidim::ParticipatoryProcess.where.not(decidim_participatory_process_group_id: nil).order(weight: :asc) if user.process_groups_admin?

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

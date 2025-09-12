# frozen_string_literal: true 

module Decidim
  module RBAC 
    module OrganizationDashboardConstraintOverrides
      extend ActiveSupport::Concern 

      included do
        private
        
        def user_has_permission_to_access_dashboard?
          record = user.accessible_records

          RBAC.policy(:admin_dashboard).new(
            record:,
            subject: user

          ).apply(:admin_read)
        end
      end
    end
  end
end
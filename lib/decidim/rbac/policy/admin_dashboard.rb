# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AdminDashboard < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end

         def allowed?(operation)
          # If the permission owner has permission to read the admin dashboard for 
          # one of its records,it should have the permission to read the dashboard.

          @record ||= subject.find_all_record_types(
            [
              "Decidim::Assembly", 
              "Decidim::ParticipatoryProcess", 
              "Decidim::ParticipatoryGroupProcess"
            ], context[:current_organization])

          super
        end
      end
    end
  end
end
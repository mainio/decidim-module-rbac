# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class AdminDashboard < Default
        def able?(operation)
          able_to_read_publicly?(operation)
        end

        def allowed?(_operation)
          # If the user has any role on any record
          # that gives the permission to access admin dashboard
          # they should be allowed
          @record ||= subject.find_all_record_types(
            [
              "Decidim::ParticipatoryProcess",
              "Decidim::ParticipatoryProcessGroup",
              "Decidim::Assembly"
            ]
          )

          super
        end
      end
    end
  end
end
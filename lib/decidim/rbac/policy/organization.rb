# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Organization < Default
        def able?(operation)
          return false unless operation == :admin_update
          return false unless subject
          return false unless subject.respond_to?(:organization)

          record == subject.organization
        end
      end
    end
  end
end

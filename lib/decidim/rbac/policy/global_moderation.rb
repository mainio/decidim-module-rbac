# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class GlobalModeration < Default
        def able?(operation)
          return false unless operation == :admin_read
          return false unless subject
          return false unless subject.respond_to?(:admin_terms_accepted?)

          subject.admin_terms_accepted?
        end
      end
    end
  end
end

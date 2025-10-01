# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class GlobalModeration < Default
        def allowed?(operation)
          return false if subject.blank?

          @record ||= subject.accessible_records

          super
        end
      end
    end
  end
end

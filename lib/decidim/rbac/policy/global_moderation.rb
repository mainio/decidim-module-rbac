# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class GlobalModeration < Default
        def allowed?(operation)
          return unless subject.present?

          @record ||= subject.accessible_records

          super
        end
      end
    end
  end
end

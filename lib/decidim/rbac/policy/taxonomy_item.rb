# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class TaxonomyItem < Default
        context_reader :taxonomy

        def able?(operation)
          case operation
          when :admin_create
            true
          when :admin_update
            record.present?
          else
            false
          end
        end

        private

        def record
          super || taxonomy
        end
      end
    end
  end
end

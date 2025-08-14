# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class TaxonomyFilter < Default
        def able?(operation)
          case operation
          when :admin_index, :admin_show, :admin_create
            true
          when :admin_update, :admin_destroy
            record.present?
          else
            false
          end
        end
      end
    end
  end
end

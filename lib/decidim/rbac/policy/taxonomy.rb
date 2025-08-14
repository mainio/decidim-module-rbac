# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Taxonomy < Default
        def able?(operation)
          case operation
          when :admin_index, :admin_show, :admin_create
            true
          when :admin_update
            record.present?
          when :admin_destroy
            record&.removable?
          else
            false
          end
        end
      end
    end
  end
end

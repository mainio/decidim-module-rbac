# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class StaticPage < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create
            true
          when :admin_update
            record.present?
          when :admin_update_slug, :admin_destroy
            record.present? && !StaticPage.default?(record.slug)
          when :admin_update_notable_changes
            record.slug == "terms-of-service" && record.persisted?
          else
            false
          end
        end
      end
    end
  end
end

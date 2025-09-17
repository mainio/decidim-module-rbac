# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Attachment < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create
            record.present?
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

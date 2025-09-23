# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Newsletter < Default
        def able?(operation)
          case operation
          when :admin_index, :admin_create
            true
          when :admin_read, :admin_update, :admin_destroy
            return false if record.blank?

            user == record.author
          else
            false
          end
        end
      end
    end
  end
end

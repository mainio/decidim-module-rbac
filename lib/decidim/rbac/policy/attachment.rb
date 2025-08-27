# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Attachment < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create
            can_read_attachment?
          when :admin_update, :admin_destroy
            record.present?
          else
            false
          end
        end

        private 

        def can_read_attachment?
          return false unless record

          record.attachments_enabled?
        end
      end
    end
  end
end

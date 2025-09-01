# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Moderation < Default
        def able?(operation)
          case operation
          when :admin_read, :admin_create
            true
          else
            false
          end
        end

        def allowed?(_operation)
          @record ||=
            subject.accessible_records
          super
        end
      end
    end
  end
end

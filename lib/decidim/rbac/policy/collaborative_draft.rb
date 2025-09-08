# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class CollaborativeDraft < Default
        context_reader :collaborative_draft

        def able?(operation)
          case operation
          when :react_to_request_access
            # TODO
          when :create
            # TODO
          when :arequest_access
            # TODO
          when :publish
            # TODO
          when :edit 
            # TODO
          end
        end

        private

        def record
          super || document
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Comment < Default
        context_reader :commentable

        def able?(operation)
          case operation
          when :read
            commentable.commentable?
          when :create
            return false if subject.blank?
            return false unless commentable&.commentable?

            commentable.user_allowed_to_comment?(subject)
          when :update, :destroy
            return false if subject.blank?
            return false if record.blank?

            record.authored_by?(subject)
          when :vote
            return false if subject.blank?
            return false unless commentable&.commentable?

            commentable.user_allowed_to_vote_comment?(subject)
          else
            false
          end
        end

        private

        def commentable
          record&.root_commentable || super
        end
      end
    end
  end
end

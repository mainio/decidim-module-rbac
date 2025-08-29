# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Comment < Default
        context_reader :commentable

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          return unless record.present?
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
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        private

        def commentable
          return record unless record.is_a?(::Decidim::Comments::Comment)
          
          record.root_commentable
        end
      end
    end
  end
end

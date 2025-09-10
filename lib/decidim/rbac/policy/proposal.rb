# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Proposal < Default
        context_reader :current_settings, :component, :component_settings

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def able?(operation)
          case operation
          when :read, :admin_read, :report
            true
          when :create
            # TODO: Authorization check
            current_settings&.creation_enabled?
          when :admin_create
            return false if component_settings.participatory_texts_enabled?

            current_settings&.creation_enabled? &&
              component_settings&.official_proposals_enabled
          when :edit
            record.present?
          when :admin_edit
            return false unless record
            return false unless record.official? || record.official_meeting?

            record.votes.empty?
          when :withdraw, :admin_withdraw
            record && !record.withdrawn?
          when :amend
            # TODO: Authorization check
            record && current_settings&.amendments_enabled?
          when :vote
            # TODO: Authorization check
            record && voting_enabled? && remaining_votes.positive?
          when :unvote
            # TODO: Authorization check
            record && voting_enabled?
          else
            false
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def allowed?(operation)
          case operation
          when :read
            return true if super(:admin_read)

            !proposal.hidden
          else

            super
          end
        end

        private

        def voting_enabled?
          return false unless current_settings

          current_settings&.votes_enabled? && !current_settings&.votes_blocked?
        end

        def remaining_votes
          return 1 unless vote_limit_enabled?

          proposals = Proposal.where(component:)
          votes_count = ProposalVote.where(author: subject, proposal: proposals).size
          component_settings.vote_limit - votes_count
        end
      end
    end
  end
end

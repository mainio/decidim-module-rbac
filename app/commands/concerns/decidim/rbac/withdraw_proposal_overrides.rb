# frozen_string_literal: true

module Decidim
  module RBAC
    module WithdrawProposalOverrides
      extend ActiveSupport::Concern

      included do
        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the proposal.
        # - :has_votes if the proposal already has votes or does not belong to current user.
        #
        # Returns nothing.
        def call
          return broadcast(:has_votes) if @proposal.votes.any?

          transaction do
            @proposal.withdraw!
            @current_user.unassign_role!("proposal_author", @proposal)
            reject_emendations_if_any
          end

          broadcast(:ok, @proposal)
        end
      end
    end
  end
end

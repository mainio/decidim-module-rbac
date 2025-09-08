# frozen_string_literal: true 

module Decidim
  module RBAC
    module CreateProposalOverrides
      include CreatePermissionRoleAssignment
      
      extend ActiveSupport::Concern

      included do
        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the proposal.
        # - :invalid if the form was not valid and we could not proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          if proposal_limit_reached?
            form.errors.add(:base, I18n.t("decidim.proposals.new.limit_reached"))
            return broadcast(:invalid)
          end

          if process_attachments?
            build_attachments
            return broadcast(:invalid) if attachments_invalid?
          end

          with_events(with_transaction: true) do
            create_proposal
            create_attachments(first_weight: first_attachment_weight) if process_attachments?
            create_permission_role(@proposal, @current_user, "proposal_author")
          end

          broadcast(:ok, proposal)
        end
      end
    end
  end
end
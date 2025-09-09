# frozen_string_literal: true 

module Decidim
  module RBAC
    module AcceptAccessToCollaborativeDraftOverrides
      include CreatePermissionRoleAssignment
      
      extend ActiveSupport::Concern

      included do
        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if it was not valid and we could not proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if @form.invalid?
          return broadcast(:invalid) if @current_user.nil?

          transaction do
            @collaborative_draft.requesters.delete @requester_user

            Decidim::Coauthorship.create(
              coauthorable: @collaborative_draft,
              author: @requester_user
            )
          end

          create_permission_role(@collaborative_draft, @requester_user, "collaborative_draft_author")
          notify_collaborative_draft_requester
          notify_collaborative_draft_authors
          broadcast(:ok, @requester_user)
        end
      end
    end
  end
end
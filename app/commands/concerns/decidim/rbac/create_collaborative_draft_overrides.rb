# frozen_string_literal: true 

module Decidim
  module RBAC
    module CreateCollaborativeDraftOverrides
      include CreatePermissionRoleAssignment
      
      extend ActiveSupport::Concern

      included do
        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the collaborative draft.
        # - :invalid if the form was not valid and we could not proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          if process_attachments?
            build_attachments
            return broadcast(:invalid) if attachments_invalid?
          end

          with_events(with_transaction: true) do
            create_collaborative_draft
            create_attachments if process_attachments?
          end
          create_permission_role(@collaborative_draft, @current_user, "collaborative_draft_author")

          broadcast(:ok, collaborative_draft)
        end
      end
    end
  end
end
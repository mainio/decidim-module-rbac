# frozen_string_literal: true

module Decidim
  module RBAC
    module DestroyAccountExtensions
      extend ActiveSupport::Concern

      included do
        def call
          return broadcast(:invalid) unless @form.valid?

          Decidim::User.transaction do
            destroy_user_account!
            destroy_user_identities
            destroy_follows
            destroy_participatory_space_private_user
            delegate_destroy_to_participatory_spaces
            unassign_roles!
          end

          broadcast(:ok)
        end

        private

        def unassign_roles!
          current_user.unassign_all_roles!
        end
      end
    end
  end
end
# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProposalAnswer < Default
        context_reader :current_settings, :component_settings, :proposal

        def able?(operation)
          return false unless operation == :admin_create
          return false if proposal.blank?

          current_settings&.proposal_answering_enabled &&
            component_settings&.proposal_answering_enabled
        end

        def allowed?(operation)
          @record ||=
            proposal.participatory_space

          super
        end
      end
    end
  end
end

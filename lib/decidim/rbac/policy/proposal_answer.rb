# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ProposalAnswer < Default
        context_reader :current_settings, :component_settings

        def able?(operation)
          return false unless operation == :admin_create

          current_settings&.proposal_answering_enabled &&
            component_settings&.proposal_answering_enabled
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class ParticipatoryTexts < Default
        context_reader :component_settings

        def able?(operation)
          return false unless operation == :admin_manage

          component_settings.participatory_texts_enabled?
        end
      end
    end
  end
end

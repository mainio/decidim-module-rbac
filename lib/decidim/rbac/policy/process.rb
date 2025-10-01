# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Process < ParticipatorySpace
        context_reader :process

        def able?(_operation)
          self.record ||= process
        end

        private

        def participatory_space
          @participatory_space ||=
            process || super
        end
      end
    end
  end
end

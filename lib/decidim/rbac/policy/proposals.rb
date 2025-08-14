# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Proposals < Default
        def able?(operation)
          case operation
          when :admin_publish_answers, :admin_import, :admin_export, :admin_merge, :admin_split, :admin_assign_to_evaluator, :admin_unassign_from_evaluator
            true
          else
            false
          end
        end
      end
    end
  end
end

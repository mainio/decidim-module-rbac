# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Moderation < Default
        context_reader :process, :assembly, :current_participatory_space

        def allowed?(operation)
          case operation 
          when :create
            return true
          when :admin_read
            @record = process || assembly || current_participatory_space
          else 
            @record = subject.accessible_records
          end

          super
        end
      end
    end
  end
end

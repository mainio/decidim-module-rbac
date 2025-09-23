# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Moderation < Default
        context_reader :process, :assembly, :current_participatory_space

        def able?(operation)
          case operation
          when :admin_hide, :admin_unhide, :admin_unreport, :dmin_read
            @record.present?
          else 
            super
          end
        end

        def allowed?(operation)
          @record ||= participatory_space
          
          super
        end

        private

        def participatory_space
          @participatory_space ||= current_participatory_space || 
            assembly ||
            process ||
            super
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Moderation < Default
        context_reader :process, :assembly, :current_participatory_space

        def allowed?(operation)
          case operation
          when :admin_hide, :admin_unhide, :admin_unreport, :admin_read
            @record = participatory_space
          else
            @record ||= participatory_space || subject&.organization
          end

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

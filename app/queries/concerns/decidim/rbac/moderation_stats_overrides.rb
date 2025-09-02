# frozen_string_literal: true 

module Decidim 
  module RBAC 
    module ModerationStatsOverrides
      extend ActiveSupport::Concern

      included do

        def content_moderations
          @content_moderations ||= 
            if user.is_organization_admin?
              ::Decidim::Moderation.all
            else
              ::Decidim::Moderation.where(participatory_space: user.accessible_records)
            end
        end
      end
    end
  end
end
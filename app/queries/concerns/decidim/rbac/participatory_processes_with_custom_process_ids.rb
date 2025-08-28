# frozen_string_literal: true 

module Decidim 
  module RBAC 
    module ParticipatoryProcessesWithCustomProcessIds
      extend ActiveSupport::Concern

      included do

        def query
          ParticipatoryProcess.where(id: process_ids)
        end

        private 

        def process_ids
          user.find_all_record_types("Decidim::ParticipatoryProcess").map(&:id)
        end
      end
    end
  end
end
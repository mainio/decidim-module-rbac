# frozen_string_literal: true

module Decidim
  module RBAC
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::RBAC

      initializer "decidim_rbac.events" do
        ActiveSupport::Notifications.subscribe("decidim.proposals.create_proposal:after") do |_event_name, data|
          proposal = data[:resource]
          author = data[:extra][:event_author]

          # TODO: Assign the coauthor role
        end

        ActiveSupport::Notifications.subscribe("decidim.events.proposals.accepted_coauthorship") do |_event_name, data|
          proposal = data[:resource]
          author = data[:affected_users].first

          # TODO: Assign the coauthor role
        end
      end

      initializer "decidim_rbac.customizations" do
        config.to_prepare do
          # Models
          Decidim::UserBaseEntity.include(Decidim::RBAC::PermissionSubject)
        end
      end
    end
  end
end

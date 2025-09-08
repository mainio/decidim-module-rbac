# frozen_string_literal: true

module Decidim
  module RBAC
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::RBAC

      # rubocop:disable Lint/UselessAssignment
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
      # rubocop:enable Lint/UselessAssignment

      initializer "decidim_rbac.permissions" do
        next unless defined?(Rails)
        next unless Rails.application

        PermissionLoader.load!
      end

      initializer "decidim_rbac.override_needs_permission" do 
        # In order to make this module work, we need to over-ride the core `NeedsPermission` concern.
        # The best way to do that is to remove the constant from the Zeitwerk, and load the file from the module.
        # otherwise we need to include this over-ride to each and every class that implements NeedsPermission.
        # After being merged to the core, this would simply be removed by replacing the content.
        config.to_prepare do
          Decidim.send(:remove_const, :NeedsPermission)
          load ::Decidim::RBAC::Engine.root.join("lib/decidim/needs_permission.rb")
        end
      end

      initializer "decidim_rbac.customizations" do
        config.to_prepare do
          # Models
          Decidim::UserBaseEntity.include(Decidim::RBAC::PermissionSubject)
          # Queries
          Decidim::ParticipatoryProcessesWithUserRole.include(Decidim::RBAC::ParticipatoryProcessesWithUserRoleOverrides)
          Decidim::Assemblies::AssembliesWithUserRole.include(Decidim::RBAC::AssembliesWithUserRoleOverrides)
          Decidim::Admin::ModerationStats.include(Decidim::RBAC::ModerationStatsOverrides)
          # Commands 
          Decidim::Proposals::CreateProposal.include(Decidim::RBAC::CreateProposalOverrides)
        end
      end
    end
  end
end

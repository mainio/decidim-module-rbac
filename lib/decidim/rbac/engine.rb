# frozen_string_literal: true

module Decidim
  module RBAC
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::RBAC

      initializer "decidim_rbac.events" do
        ActiveSupport::Notifications.subscribe("decidim.proposals.create_proposal:after") do |_event_name, data|
          proposal = data[:resource]
          author = data[:extra][:event_author]

          author.assign_role!("proposal_author" ,proposal)
        end

        ActiveSupport::Notifications.subscribe("decidim.events.proposals.accepted_coauthorship") do |_event_name, data|
          proposal = data[:resource]
          author = data[:affected_users].first

           author.assign_role!("proposal_author" ,proposal)
        end

        ActiveSupport::Notifications.subscribe("decidim.proposals.create_collaborative_draft:after") do |_event_name, data|
          collaborative_draft = data[:resource]
          author = data[:extra][:event_author]

           author.assign_role!("collaborative_draft_author" ,collaborative_draft)
        end

        ActiveSupport::Notifications.subscribe("decidim.events.proposals.collaborative_draft_access_requester_accepted") do |_event_name, data|
          collaborative_draft = data[:resource]
          author = data[:affected_users].first

           author.assign_role!("collaborative_draft_author" ,collaborative_draft)
        end

        ActiveSupport::Notifications.subscribe("decidim.events.debates.debate_created") do |_event_name, data|
          debate = data[:resource]
          author = debate.author

           author.assign_role!("debate_author" ,debate)
        end

        ActiveSupport::Notifications.subscribe("decidim.events.meetings.meeting_registration_confirmed") do |_event_name, data|
          meeting = data[:meeting]
          user = data[:affected_users].first

           author.assign_role!("meeting_register_owner" ,meeting)
        end

        ActiveSupport::Notifications.subscribe("decidim.events.blogs.post_created") do |_event_name, data|
          debate = data[:resource]
          author = data[:affected_users].first

           author.assign_role!("blog_author" ,debate)
        end
      end
      
      initializer "decidim_rbac.add_inflector_active_support" do
        ActiveSupport::Inflector.inflections(:en) do |inflect|
          inflect.acronym 'RBAC'
        end
      end

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
        # config.autoload_paths << Rails.root.join("app/queries/concerns")
        
        config.to_prepare do
          # Models
          Decidim::UserBaseEntity.include(Decidim::RBAC::PermissionSubject)
          # Queries
          Decidim::ParticipatoryProcessesWithUserRole.include(Decidim::RBAC::ParticipatoryProcessesWithUserRoleOverrides)
          Decidim::Assemblies::AssembliesWithUserRole.include(Decidim::RBAC::AssembliesWithUserRoleOverrides)
          Decidim::Admin::ModerationStats.include(Decidim::RBAC::ModerationStatsOverrides)
          # Commands
          Decidim::Proposals::WithdrawProposal.include(Decidim::RBAC::WithdrawProposalOverrides)
        end
      end
    end
  end
end

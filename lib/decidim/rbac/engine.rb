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

        # Permissions from the modules
        decidim_gems = Bundler.load.specs.select { |spec| spec.name =~ /^decidim-/ }
        decidim_gems.each do |gem|
          asset_config_path = File.join(gem.full_gem_path, "config/permissions.rb")
          next unless File.exist?(asset_config_path)

          load asset_config_path
        end

        # Application permissions
        asset_config_path = File.join(Rails.application.root, "config/permissions.rb")
        load asset_config_path if File.exist?(asset_config_path)
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
        end
      end
    end
  end
end

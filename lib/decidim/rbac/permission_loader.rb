# frozen_string_literal: true 

module Decidim
  module RBAC
    class PermissionLoader
      class << self
        def load!
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

        def reload!
          registry = Decidim::RBAC::Registry.instance
          registry.instance_variable_set(:@groups, {})
          registry.instance_variable_set(:@roles, {})
          registry.instance_variable_set(:@policies, {})

          load!
        end
      end
    end
  end
end
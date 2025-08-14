# frozen_string_literal: true

require "yaml"

module Decidim
  module RBAC
    class Scanner
      # Scans through all the Decidim modules, finds the permission definition
      # files (config/permissions.yml) in each module and converts them to role
      # definitions.
      def roles
        permission_definitions("roles") do |map|
          map.each do |key, settings|
            yield key, settings
          end
        end
      end

      # Scans through the Decidim codebase to find out all permissions and
      # operations. Grepping is not perfect for this use case but it is fast and
      # good enough for the purpose.
      #
      # Manual inspection of the result is needed.
      #
      # Known issues:
      # decidim-core/app/controllers/concerns/decidim/needs_permission.rb
      # => Results to permission "ubject" and operation "ction".
      # => Remove this (already defined).
      #
      # decidim-admin/lib/decidim/admin/engine.rb
      # => Results to illiterate permission after the ternary operator after
      #    `allowed_to?`.
      # => Remove this (already defined).
      #
      # decidim-participatory_processes/app/controllers/decidim/participatory_processes/admin/participatory_processes_controller.rb
      # => Results to permission "ecidim::ParticipatoryProcess" due to the way the
      #    enforce statement is defined.
      # => Remove this (already defined under `:process`).
      #
      # decidim-admin/app/controllers/decidim/admin/moderations_controller.rb
      # decidim-admin/app/controllers/decidim/admin/reports_controller.rb
      # => Results to permission "ermission_resource" due to the permission name
      #    defined as a call to a method.
      # => Repeat the operations defined for this permissions for all permissions
      #    keys defined in a method named `def permission_resource`.
      def scan_code
        {}.tap do |permissions|
          decidim_gems.each do |spec|
            current = {}
            Dir.glob("#{spec.full_gem_path}/{app,lib}/**/*.{rb,erb}").each do |file|
              content = File.read(file)

              if File.extname(file) == ".erb"
                content.scan(/<%.*(allowed_to\?[( ]\s*(.*)\)?)\s+%>/).each do |match|
                  args = parse_args(match[1])
                  add_permissions(current, args)
                end
              else
                content.scan(/  (enforce_permission_to[( ]\s*(.*)\)?)/).each do |match|
                  args = parse_args(match[1])
                  add_permissions(current, args)
                end
                content.scan(/  (allowed_to\?[( ]\s*(.*)\)?)/).each do |match|
                  args = parse_args(match[1])
                  add_permissions(current, args)
                end
              end
            end
            yield spec.name, current unless current.empty?
          end
        end
      end

      private

      def permission_definitions(key)
        {}.tap do |roles|
          decidim_gems.each do |spec|
            filepath = "#{spec.full_gem_path}/config/permissions.yml"
            next unless File.exist?(filepath)

            defs = YAML.load_file(filepath)
            next unless defs[key].is_a?(Hash)

            yield defs[key]
          end
        end
      end

      def decidim_gems
        @decidim_gems ||= Bundler.definition.locked_gems.specs.map do |spec|
          next unless spec.name.match?(/^decidim/)

          Gem.loaded_specs[spec.name]
        end.compact
      end

      def add_permissions(hash, args)
        hash[args[:permission]] ||= []
        hash[args[:permission]].push(args[:operation]).uniq!
      end

      def parse_args(string)
        args = string.split(/,\s+/)

        { permission: args[1][1..].sub(")", "").to_sym, operation: args[0][1..].split(/\s/).first.to_sym }
      end
    end
  end
end

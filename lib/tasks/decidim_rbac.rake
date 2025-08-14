# frozen_string_literal: true

require "#{__dir__}/../decidim/rbac"

namespace :decidim_rbac do
  # @see Decidim::RBAC::Scanner#scan_code
  desc "Scan all permissions and operations used within the application"
  task :scan do
    scanner = Decidim::RBAC::Scanner.new
    scanner.scan_code do |mod, permissions|
      puts "# #{mod}"
      permissions.each do |permission, operations|
        puts "#{permission}:"
        puts operations.sort.map { |op| "  - #{op}" }.join("\n")
      end
      puts ""
    end
  end

  desc "Generates a Markdown formatted explanation of the defined roles, permissions and operations"
  task :explain_roles do
    locale = :en

    if defined?(Rails) && Rails.root
      Rails.application.require_environment!
    else
      # Allow running this also at the root of the module
      I18n.load_path << File.expand_path("#{__dir__}/../../config/locales/#{locale}.yml")
    end

    puts "# Roles"
    puts ""

    I18n.with_locale(locale) do
      Decidim::RBAC::Registry.instance.roles.each do |role|
        puts "## #{role.name}"
        puts ""
        puts role.description
        puts ""

        rows = [["Permission", "Operations"]] + role.permissions.keys.sort.map do |key|
          operations = role.permissions[key]
          ["`:#{key}`", operations.sort.map { |op| "`:#{op}`" }.join("<br>")]
        end

        row_lengths = [0, 0]
        rows.each do |row|
          row.each_with_index do |text, idx|
            row_lengths[idx] = text.length if row_lengths[idx] < text.length
          end
        end

        rows.each_with_index do |row, rowi|
          rowtext = "| "
          row.each_with_index do |text, coli|
            pad = row_lengths[coli] - text.length
            rowtext += "#{text}#{" " * pad} | "
          end

          puts rowtext
          puts "| #{row_lengths.map { |l| "-" * l }.join(" | ")} |" if rowi == 0
        end
        puts ""
      end
    end
  end

  # This only needs to run once after the whole codebase is refactored to use RBAC.
  desc "Creates the initial role assignments after this module is installed."
  task assign_roles: :environment do
    abort "There are already roles created. This task can be only run once after installation." if Decidim::RBAC::PermissionRole.any?

    # Decidim::RBAC::PermissionRole.create!()

    Decidim::Organization.find_each do |organization|
      users = Decidim::User
      users = users.entire_collection if users.respond_to?(:entire_collection)

      users.where(organization: organization, admin: true).find_each do |user|
        # TODO: Add admin permissions within the organization
      end
    end

    if Decidim.module_installed?(:participatory_processes)
      # TODO: Add
      Decidim::ParticipatoryProcess.find_each do |space|
        Decidim::ParticipatoryProcessUserRole.where(participatory_process: space).find_each do |role|
          # role.user
          case role.role.to_sym
          when :collaborator
            # TODO: private process users
          when :admin
            # TODO
          when :moderator
            # TODO
          when :valuator
            # TODO
          end

          participatory_process
        end
      end
    end

    if Decidim.module_installed?(:assemblies)

    end

    if Decidim.module_installed?(:conferences)

    end

    # TODO: Add organization
    # TODO: Add participatory space admins
    # TODO: Add debate authors
    # TODO: Add proposal authors
    # TODO: Add comment authors
  end
end

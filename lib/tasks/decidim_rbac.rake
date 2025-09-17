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

        rows = [%w(Permission Operations)] + role.permissions.keys.sort.map do |key|
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
          puts "| #{row_lengths.map { |l| "-" * l }.join(" | ")} |" if rowi.zero?
        end
        puts ""
      end
    end
  end

  # This only needs to run once after the whole codebase is refactored to use RBAC.
  desc "Creates the initial role assignments after this module is installed."
  task assign_roles: :environment do
    abort "There are already roles created. This task can be only run once after installation." if Decidim::RBAC::PermissionRoleAssignment.any?
    records = []
    Decidim::Organization.find_each do |organization|
      users = Decidim::User
      users = users.entire_collection if users.respond_to?(:entire_collection)

      users.where(organization: organization).map do |user|
        record = {
          subject_id: user.id,
          subject_type: "Decidim::UserBaseEntity",
          role: "participant",
          record_id: organization.id,
          record_type: "Decidim::Organization"
        }
        records.push(record)
        if user.admin?
          admin_role = record.dup
          admin_role[:role] = "organization_admin"
          records.push(admin_role)
        end
      end
    end

    if Decidim.module_installed?(:participatory_processes)
      Decidim::ParticipatoryProcessUserRole.find_each do |role|
        record = {
          record_id: role.decidim_participatory_process_id,
          record_type: "Decidim::ParticipatoryProcess",
          subject_id: role.decidim_user_id,
          subject_type: "Decidim::UserBaseEntity"
        }
        record[:role] = case role.role.to_sym
        when :collaborator
          "collaborator"
        when :admin
          "process_admin"
        when :moderator
          "moderator"
        when :evaluator
          "evaluator"
        end
        records.push(record)
      end
      Decidim::ParticipatoryProcess.where(private_space: true).find_each do |space|
        space.users.map do |subject|
          records.push(
            {
              record_id: space.id,
              record_type: "Decidim::ParticipatoryProcess",
              role: "private_participant",
              subject_id: subject.id,
              subject_type: "Decidim::UserBaseEntity"
            }
          )
        end
      end

      Decidim::ParticipatorySpacePrivateUser.find_each do |role|
        records.push({
          subject_id: role.decidim_user_id,
          subject_type: "Decidim::UserBaseEntity",
          role: "private_participant",
          record_id: role.privatable_to_id,
          record_type: role.privatable_to_type
        })
      end
    end

    if Decidim.module_installed?(:assemblies)
      Decidim::AssemblyUserRole.find_each do |role|
        record = {
          record_type: "Decidim::Assembly",
          record_id: role.decidim_assembly_id,
          subject_id: role.decidim_user_id,
          subject_type: "Decidim::UserBaseEntity"
        }
        record[:role] = case role.role.to_sym
                        when :collaborator
                          "collaborator"
                        when :admin
                          "assembly_admin"
                        when :moderator
                          "moderator"
                        when :evaluator
                          "evaluator"
                        end
        records.push(record)
      end
    end

    Decidim::ParticipatorySpacePrivateUser.find_each do |role|
      records.push({
        subject_id: role.decidim_user_id,
        subject_type: "Decidim::UserBaseEntity",
        role: "private_participant",
        record_id: role.privatable_to_id,
        record_type: role.privatable_to_type
      })
    end

    if Decidim.module_installed?(:debates)
      Decidim::Debates::Debate.find_each do |debate|
        records.push({
            record_id: debate.id,
            record_type: "Decidim::Debates::Debate",
            subject_id: debate.author.id,
            subject_type: "Decidim::UserBaseEntity",
            role: "debate_author"
          }
        )
      end
    end
    Decidim::Proposals::Proposal.find_each do |proposal|
      proposal.authors.each do |author|
        records.push({
          record_id: proposal.id,
          record_type: "Decidim::Proposals::Proposal",
          subject_id: author.id,
          subject_type: "Decidim::UserBaseEntity",
          role: "proposal_author"
        }
      )
      end
    end

    Decidim::Proposals::CollaborativeDraft.find_each do |draft|
      draft.authors.each do |author|
        records.push({
          record_id: draft.id,
          record_type: "Decidim::Proposals::CollaborativeDraft",
          subject_id: author.id,
          subject_type: "Decidim::UserBaseEntity",
          role: "collaborative_draft_author"
        })
      end
    end

    if Decidim.module_installed?(:blogs)
      Decidim::Blogs::Post.find_each do |post|
        records.push({
          record_id: post.id,
          record_type: "Decidim::Blogs::Post",
          subject_id: post.author.id,
          subject_type: "Decidim::UserBaseEntity",
          role: "blog_author"
        })
      end
    end

    if Decidim.module_installed?(:meetings)
      Decidim::Meetings::Meeting.find_each do |meeting|
        records.push({
          record_id: meeting.id,
          record_type: "Decidim::Meetings::Meeting",
          subject_id: meeting.author.id,
          subject_type: "Decidim::UserBaseEntity",
          role: "meeting_author"
        })
      end

      Decidim::Meetings::Registration.where()
    end
    Decidim::RBAC::PermissionRoleAssignment.insert_all(records.uniq)

    # TODO: Add comment authors
  end
end

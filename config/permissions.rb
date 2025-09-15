# frozen_string_literal: true

Decidim::RBAC.define do |reg|
  # Most permissions are defined in groups to make it easier to apply them to
  # different roles specifically. Specific permissions can be also assigned
  # directly to the roles instead of defining them first in groups.

  # decidim-accountability
  reg.group :accountability_admin do |group|
    group.resource :import_component do |res|
      res.operation :admin_create
    end

    group.resource :result do |res|
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_create_children
      res.operation :admin_soft_delete
      res.operation :admin_restore
      res.operation :admin_manage_trash
    end

    # should be `result_timeline_entry`
    # Changed in 0.31.0: `milestone` (should be `result_milestone`)
    group.resource :timeline_entry do |res|
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :bulk_update do |res|
      res.operation :admin_create
    end

    # should be `result_status`
    group.resource :status do |res|
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end
  end

  # decidim-admin
  reg.group :admin do |group|
    group.resource :admin_dashboard do |res|
      res.operation :read
      res.operation :admin_read
    end

    group.resource :participatory_space do |res|
      res.operation :admin_read
      res.operation :admin_list
      res.operation :admin_create
      res.operation :admin_import
      res.operation :admin_preview
      res.operation :admin_update
      res.operation :admin_publish
      res.operation :admin_soft_delete
      res.operation :admin_destroy
      res.operation :admin_restore
    end

    group.resource :export_space do |res|
      res.operation :admin_create
    end

    group.resource :area_type do |res|
      res.operation :admin_read
      res.operation :admin_craete
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :area do |res|
      res.operation :admin_read
      res.operation :admin_craete
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :authorization do |res|
      res.operation :admin_index
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :authorization_workflow do |res|
      res.operation :admin_index
    end

    group.resource :attachment_collection do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :attachment do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :admin_user do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_block
      res.operation :admin_invite
      res.operation :admin_destroy
    end

    group.resource :component do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_reorder
      res.operation :admin_manage_trash
      res.operation :admin_manage
      res.operation :admin_update
      res.operation :admin_publish
      res.operation :admin_unpublish
      res.operation :admin_share
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end

    group.resource :component_data do |res|
      res.operation :admin_import
      res.operation :admin_export
    end

    group.resource :impersonatable_user do |res|
      res.operation :admin_index
      res.operation :admin_promote
      res.operation :admin_impersonate
    end

    group.resource :help_sections do |res|
      res.operation :admin_update
    end

    group.resource :admin_log do |res|
      res.operation :admin_read
    end

    group.resource :global_moderation do |res|
      res.operation :admin_read
    end

    group.resource :moderation do |res|
      res.operation :admin_read
      res.operation :admin_unhide
      res.operation :admin_unreport
    end

    group.resource :moderate_users do |res|
      res.operation :admin_destroy
      res.operation :admin_block
      res.operation :admin_read
      res.operation :admin_unreport
    end

    group.resource :newsletter do |res|
      res.operation :admin_index
      res.operation :admin_create
      res.operation :admin_read
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :officialization do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_destroy
      res.operation :admin_index
    end

    group.resource :user do |res|
      res.operation :admin_show_email
    end

    group.resource :user do |res|
      res.operation :admin_show_email
    end

    group.resource :organization do |res|
      res.operation :admin_update
    end

    group.resource :reminder do |res|
      res.operation :admin_create
    end

    group.resource :scope_type do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :scope do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :share_token do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :static_page do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_update_slug
      res.operation :admin_destroy
      res.operation :admin_update_notable_changes
    end

    group.resource :static_page_topic do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :statistics do |res|
      res.operation :admin_read
    end

    group.resource :taxonomy do |res|
      res.operation :admin_index
      res.operation :admin_show
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :taxonomy_filter do |res|
      res.operation :admin_index
      res.operation :admin_show
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :taxonomy_item do |res|
      res.operation :admin_create
      res.operation :admin_update
    end

    group.resource :space_private_user do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_csv_import
      res.operation :admin_update
      res.operation :admin_edit
      res.operation :admin_destroy
      res.operation :admin_invite
    end

    group.resource :space_area do |res|
      res.operation :admin_enter
    end

    group.resource :managed_user do |res|
      res.operation :admin_read
      res.operation :admin_promote
      res.operation :impersonate
    end

    group.resource :users_statistics do |res|
      res.operation :admin_read
    end
  end

  # decidim-assemblies
  reg.group :assemblies do |group|
    group.resource :assembly do |res|
      res.operation :read
      res.operation :list
    end

    group.resource :members do |res|
      res.operation :list
    end
  end

  reg.group :assemblies_admin do |group|
    group.resource :assembly do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_import
      res.operation :admin_update
      res.operation :admin_publish
      res.operation :admin_export
      res.operation :admin_copy
      res.operation :admin_preview
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end

    group.resource :assembly_list do |res|
      res.operation :admin_read
    end

    group.resource :assembly_user_role do |res|
      res.operation :admin_create
      res.operation :admin_read
      res.operation :admin_invite
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :space_area do |res|
      res.operation :admin_enter
    end

    group.resource :members do |res|
      res.operation :admin_read
    end

    group.resource :component do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_reorder
      res.operation :admin_manage_trash
      res.operation :admin_manage
      res.operation :admin_update
      res.operation :admin_publish
      res.operation :admin_unpublish
      res.operation :admin_share
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end

    group.resource :attachment_collection do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :attachment do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :space_private_user do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_csv_import
      res.operation :admin_update
      res.operation :admin_edit
      res.operation :admin_destroy
      res.operation :admin_invite
    end

    group.resource :moderation do |res|
      res.operation :admin_create
      res.operation :admin_read
    end

    group.resource :share_token do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end
  end

  # decidim-blogs
  reg.group :blogs do |group|
    group.resource :blogpost do |res|
      res.operation :read
      res.operation :create
    end
  end

  reg.group :blogs_author do |group|
    group.resource :blogpost do |res|
      res.operation :update
      res.operation :destroy
    end
  end

  reg.group :blogs_admin do |group|
    group.resource :blogpost do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_manage_trash
      res.operation :admin_update
      res.operation :admin_destroy
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end
  end

  # decidim-budgets
  reg.group :budgets do |group|
    group.resource :order do |res|
      res.operation :create
      res.operation :export_pdf
    end

    group.resource :project do |res|
      res.operation :vote
      res.operation :read
      res.operation :report
    end
  end

  reg.group :budgets_admin do |group|
    group.resource :budget do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_export
      res.operation :admin_manage_trash
      res.operation :admin_update
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end

    group.resource :project do |res|
      res.operation :admin_create
      res.operation :admin_manage_trash
      res.operation :admin_update
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end

    group.resource :projects do |res|
      res.operation :admin_import_proposals
    end

    group.resource :project_taxonomy do |res|
      res.operation :admin_update
    end

    group.resource :project_selected do |res|
      res.operation :admin_update
    end

    group.resource :order do |res|
      res.operation :admin_remind
    end
  end

  # decidim-collaborative_texts
  reg.group :collaborative_texts do |group|
    group.resource :collaborative_text do |res|
      res.operation :suggest
      res.operation :rollout
    end
  end

  reg.group :collaborative_texts_admin do |group|
    group.resource :collaborative_text do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_manage_trash
      res.operation :admin_update
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end
  end

  # decidim-comments
  reg.group :comments do |group|
    group.resource :comment do |res|
      res.operation :read
      res.operation :create
      res.operation :update
      res.operation :destroy
      res.operation :vote
    end
  end

  # decidim-core
  reg.group :core do |group|
    group.resource :editor_image do |res|
      res.operation :create
    end

    group.resource :like do |res|
      res.operation :create
      res.operation :withdraw
    end

    group.resource :follow do |res|
      res.operation :create
      res.operation :delete
    end

    group.resource :participatory_space do |res|
      res.operation :read
      res.operation :list
    end

    # Has to be specific to the authorization
    # group.resource :authorization do |res|
    #   res.operation :create
    #   res.operation :update
    #   res.operation :destroy
    #   res.operation :renew
    # end

    group.resource :geolocation do |res|
      res.operation :locate
    end

    group.resource :locales do |res|
      res.operation :create
    end

    group.resource :user do |res|
      res.operation :read
      res.operation :show
      res.operation :export
      res.operation :download
      res.operation :update
      res.operation :update_profile
      res.operation :delete
    end

    group.resource :user_report do |res|
      res.operation :create
    end

    group.resource :moderation do |res|
      res.operation :create
    end

    group.resource :amendment do |res|
      res.operation :create
      # Specific to the amended resource
      # res.operation :accept
      # res.operation :reject
      # res.operation :promote
      # res.operation :withdraw
    end

    group.resource :notification do |res|
      res.operation :read
      # Specific to the notification
      # res.operation :destroy
    end

    group.resource :public_page do |res|
      res.operation :read
    end

    group.resource :component do |res|
      res.operation :read
    end

    group.resource :conversation do |res|
      res.operation :list
      res.operation :read
      res.operation :create
      res.operation :update
    end
  end

  # decidim-debates
  reg.group :debates do |group|
    group.resource :debate do |res|
      res.operation :create
      res.operation :read
      res.operation :like
    end
  end

  reg.group :debates_admin do |group|
    group.resource :debate do |res|
      res.operation :admin_create
      res.operation :admin_read
      res.operation :admin_export
      res.operation :admin_update
      res.operation :admin_close
    end
  end

  # decidim-meetings
  reg.group :meetings do |group|
    group.resource :meeting do |res|
      res.operation :read
      res.operation :list
    end

    group.resource :response do |res|
      res.operation :create
    end

    group.resource :question do |res|
      res.operation :update
    end

    group.resource :poll do |res|
      res.operation :update
    end
  end

  reg.group :meetings_admin do |group|
    group.resource :meeting do |res|
      res.operation :admin_close
      res.operation :admin_copy
      res.operation :admin_export_registrations
      res.operation :admin_update
      res.operation :admin_read_invites
      res.operation :admin_invite_attendee
      res.operation :admin_validate_registration_code
      res.operation :admin_create
    end

    group.resource :questionnaire do |res|
      res.operation :admin_update
      res.operation :admin_export_responses
    end

    group.resource :agenda do |res|
      res.operation :admin_create
      res.operation :admin_update
    end

    group.resource :poll do |res|
      res.operation :admin_update
    end
  end

  # decidim-pages
  reg.group :pages_admin do |group|
    group.resource :page do |res|
      res.operation :admin_update
    end
  end

  # decidim-participatory_processes
  reg.group :participatory_space_admin do |group|
    group.resource :admin_dashboard do |res|
      res.operation :read
      res.operation :admin_read
    end

    # Some of the participatory space related permissions are checked against
    # `participatory_space` instead of the targeted space. Therefore, duplicate
    # all these permissions under `participatory_space`.
    group.resource :participatory_space do |res|
      res.operation :read
      res.operation :admin_read
    end

    # Should be `participatory_space` -> `export`
    group.resource :export_space do |res|
      res.operation :create
    end
  end

  reg.group :participatory_processes do |group|
    group.resource :process do |res|
      res.operation :read
      res.operation :list
    end

    group.resource :process_group do |res|
      res.operation :read
      res.operation :list
    end

    group.resource :members do |res|
      res.operation :list
    end
  end

  reg.group :participatory_processes_admin do |group|
    group.resource :process do |res|
      res.operation :admin_preview
      res.operation :admin_read
      res.operation :admin_list
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
      res.operation :admin_import
      res.operation :admin_publish
      res.operation :admin_soft_delete
      res.operation :admin_restore
      res.operation :admin_destroy
    end

    group.resource :space_area do |res|
      res.operation :admin_enter
    end

    group.resource :process_list do |res|
      res.operation :admin_read
      res.operation :admin_create
    end

    group.resource :process_group do |res|
      res.operation :admin_list
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_destroy
      res.operation :admin_update
    end

    group.resource :process_step do |res|
      res.operation :admin_activate
      res.operation :admin_create
      res.operation :admin_destroy
      res.operation :admin_read
      res.operation :admin_reorder
      res.operation :admin_update
    end

    group.resource :component do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_reorder
      res.operation :admin_manage_trash
      res.operation :admin_manage
      res.operation :admin_update
      res.operation :admin_publish
      res.operation :admin_unpublish
      res.operation :admin_share
      res.operation :admin_soft_delete
      res.operation :admin_restore
    end

     group.resource :attachment_collection do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :attachment do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :space_private_user do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_csv_import
      res.operation :admin_update
      res.operation :admin_edit
      res.operation :admin_destroy
      res.operation :admin_invite
    end

    group.resource :moderation do |res|
      res.operation :admin_create
      res.operation :admin_read
    end

    group.resource :share_token do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end
  end

  # decidim-proposals
  reg.group :proposals do |group|
    group.resource :proposal do |res|
      res.operation :read
      res.operation :create
      res.operation :amend
      res.operation :vote
      res.operation :unvote
      res.operation :report
    end
  end

  reg.group :collaborative_drafts do |group|
    group.resource :collaborative_draft do |res|
      res.operation :create
      res.operation :request_access
    end
  end

  reg.group :proposals_admin do |group|
    group.resource :proposal do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_edit
    end

    group.resource :proposal_answer do |res|
      res.operation :admin_create
    end

    group.resource :proposal_note do |res|
      res.operation :admin_create
    end

    group.resource :proposal_state do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end

    group.resource :proposal_taxonomy do |res|
      res.operation :admin_update
    end

    group.resource :participatory_texts do |res|
      res.operation :admin_manage
    end
  end

  reg.group :proposals_author do |group|
    group.resource :proposal do |res|
      res.operation :edit
      res.operation :withdraw
    end
  end

  reg.group :collaborative_drafts_author do |group|
    group.resource :collaborative_draft do |res|
      res.operation :edit
      res.operation :publish
      res.operation :react_to_request_access
      res.operation :withdraw
    end
  end


  # decidim-sortitions
  reg.group :sortitions_admin do |group|
    group.resource :sortition do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end
  end

  # decidim-surveys
  reg.group :surveys do |group|
    group.resource :questionnaire do |res|
      res.operation :respond
    end
  end

  reg.group :surveys_admin do |group|
    group.resource :questionnaire do |res|
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_preview
      res.operation :admin_export_responses
      res.operation :admin_destroy
    end

    group.resource :questionnaire_responses do |res|
      res.operation :admin_index
      res.operation :admin_show
      res.operation :admin_export_response
    end

    group.resource :questionnaire_publish_responses do |res|
      res.operation :admin_index
      res.operation :admin_update
      res.operation :admin_destroy
    end
  end

  # decidim-templates
  reg.group :templates_admin do |group|
    group.resource :template do |res|
      res.operation :admin_read
      res.operation :admin_index
      res.operation :admin_create
      res.operation :admin_copy
    end

    group.resource :templates do |res|
      res.operation :admin_index
      res.operation :admin_read
    end
  end

  ##############################################################################
  ################################ ROLES BELOW #################################
  ##############################################################################

  reg.role :organization_admin do |role|
    # Common admin permissions
    role.apply :admin

    # Participatory spaces
    role.apply :participatory_space_admin
    role.apply :assemblies_admin
    role.apply :participatory_processes_admin

    # Components
    role.apply :accountability_admin
    role.apply :blogs_admin
    role.apply :budgets_admin
    role.apply :collaborative_texts_admin
    role.apply :debates_admin
    role.apply :meetings_admin
    role.apply :meetings
    role.apply :pages_admin
    role.apply :proposals_admin
    role.apply :sortitions_admin
    role.apply :surveys_admin
    role.apply :templates_admin
  end

  # === Limited admin roles ===
  reg.role :assembly_admin do |role|
    role.apply :participatory_space_admin
    role.apply :assemblies_admin

    # Components
    role.apply :accountability_admin
    role.apply :blogs_admin
    role.apply :budgets_admin
    role.apply :collaborative_texts_admin
    role.apply :debates_admin
    role.apply :meetings_admin
    role.apply :meetings
    role.apply :pages_admin
    role.apply :proposals_admin
    role.apply :sortitions_admin
    role.apply :surveys_admin
    role.apply :templates_admin
  end

  reg.role :process_admin do |role|
    role.apply :participatory_space_admin
    role.apply :participatory_processes_admin

    # Components
    role.apply :accountability_admin
    role.apply :blogs_admin
    role.apply :budgets_admin
    role.apply :collaborative_texts_admin
    role.apply :debates_admin
    role.apply :meetings_admin
    role.apply :meetings
    role.apply :pages_admin
    role.apply :proposals_admin
    role.apply :sortitions_admin
    role.apply :surveys_admin
    role.apply :templates_admin
    role.apply :private_participant
  end

  reg.role :user_manager do |role|
    # decidim-admin
    role.resource :admin_dashboard do |res|
      res.operation :read
      res.operation :admin_read
    end

    role.resource :user do |res|
      res.operation :admin_show_email
    end

    role.resource :users_statistics do |res|
      res.operation :admin_read
    end

    role.resource :impersonatable_user do |res|
      res.operation :admin_index
      res.operation :admin_promote
      res.operation :admin_impersonate
    end

    role.resource :officialization do |res|
      res.operation :admin_read
      res.operation :admin_create
      res.operation :admin_destroy
      res.operation :admin_index
    end

    role.resource :moderate_users do |res|
      res.operation :admin_destroy
      res.operation :admin_block
      res.operation :admin_read
      res.operation :admin_unreport
    end

    role.resource :managed_user do |res|
      res.operation :admin_read
      res.operation :admin_promote
      res.operation :impersonate
    end

    # decidim-verifications
    role.resource :authorization do |res|
      res.operation :admin_index
      res.operation :admin_create
      res.operation :admin_update
      res.operation :admin_destroy
    end
  end

  reg.role :evaluator do |role|
    # decidim-admin
    role.resource :proposal do |res|
      res.operation :admin_read
    end
    
    role.resource :process_list do |res|
      res.operation :admin_read
    end

    role.resource :space_area do |res|
      res.operation :admin_enter
    end

    role.resource :process do |res|
      res.operation :admin_preview
      res.operation :admin_read
    end

    role.resource :participatory_space do |res|
      res.operation :admin_read
    end

    role.resource :assembly do |res|
      res.operation :admin_read
      res.operation :admin_preview
    end

    role.resource :component do |res|
      res.operation :admin_read
    end

    role.resource :admin_dashboard do |res|
      res.operation :read
      res.operation :admin_read
    end

    # decidim-proposals
    role.resource :proposal_answer do |res|
      res.operation :admin_create
    end

    role.resource :proposal_note do |res|
      res.operation :admin_create
    end
  end

  # # === Member roles ===
  reg.role :private_participant do |role|
    # General permissions
    role.apply :core

    # Components
    role.apply :blogs
    role.apply :budgets
    role.apply :collaborative_texts
    role.apply :comments
    role.apply :debates
    role.apply :meetings
    role.apply :proposals
    role.apply :collaborative_drafts
    role.apply :surveys

    # Participatory spaces
    role.apply :assemblies
    role.apply :participatory_processes

    role.resource :authorization do |res|
      res.operation :create
    end

    # Removed in 0.31.0
    role.resource :user_group do |res|
      res.operation :create
      res.operation :join
      res.operation :leave
    end
  end

  # === Participant roles ===
  reg.role :participant do |role|
    # General permissions
    role.apply :core

    # Components
    role.apply :blogs
    role.apply :budgets
    role.apply :collaborative_texts
    role.apply :comments
    role.apply :debates
    role.apply :meetings
    role.apply :proposals
    role.apply :collaborative_drafts
    role.apply :surveys

    # Participatory spaces
    role.apply :assemblies
    role.apply :participatory_processes

    role.resource :authorization do |res|
      res.operation :create
    end

    # Removed in 0.31.0
    role.resource :user_group do |res|
      res.operation :create
      res.operation :join
      res.operation :leave
    end
  end

  reg.role :authorization_owner do |role|
    # decidim-verifications
    role.resource :authorization do |res|
      res.operation :update
      res.operation :destroy
      res.operation :renew
    end
  end

  reg.role :notification_owner do |role|
    # decidim-core
    role.resource :notification do |res|
      res.operation :destroy
    end
  end

  reg.role :amendment_author do |role|
    # decidim-core
    role.resource :amendment do |res|
      res.operation :accept
      res.operation :reject
      res.operation :withdraw
    end
  end

  reg.role :conversation_author do |role|
    # decidim-core
    role.resource :conversation do |res|
      res.operation :update
    end
  end

  reg.role :conversation_participant do |role|
    # decidim-core
    role.resource :conversation do |res|
      res.operation :list
      res.operation :read
      res.operation :show
    end
  end

  reg.role :comment_author do |role|
    # decidim-comments
    role.resource :comment do |res|
      res.operation :create
      res.operation :destroy
      res.operation :read
      res.operation :update
      res.operation :vote
    end
  end

  reg.role :debate_author do |role|
    # decidim-debates
    role.resource :debate do |res|
      res.operation :close
      res.operation :edit
      res.operation :update
    end
  end

  reg.role :meeting_author do |role|
    # decidim-meetings
    role.resource :agenda do |res|
      res.operation :create
      res.operation :update
    end

    role.resource :meeting do |res|
      res.operation :close
      res.operation :update
      res.operation :withdraw
    end
  end

  reg.role :meeting_participant do |role|
    # decidim-meetings
    role.resource :meeting do |res|
      res.operation :leave
    end
  end

  reg.role :proposal_author do |role|
    role.apply :proposals_author
  end

  reg.role :blog_author do |role|
    role.apply :blogs_author
  end

  reg.role :collaborative_draft_author do |role|
    # decidim-proposals
    role.apply :collaborative_drafts_author
  end

  # Groups will be gone in 0.31.0
  reg.role :group_admin do |role|
    # decidim-core
    role.resource :user_group do |res|
      res.operation :manage
    end
  end

  # Groups will be gone in 0.31.0
  reg.role :group_member do |role|
    # decidim-core
    role.resource :user_group do |res|
      res.operation :leave
    end
  end

  # === Participant and visitor roles ===
  reg.role :form_answer_author do |role|
    # decidim-forms
    # decidim-surveys
    role.resource :questionnaire_answers do |res|
      res.operation :show
    end
  end

  # === Visitor roles ===
  reg.role :visitor do |role|
    # decidim-assemblies
    role.resource :assembly do |res|
      res.operation :read
    end

    # should be `assembly_members`
    role.resource :members do |res|
      res.operation :list
    end

    role.resource :participatory_space do |res|
      res.operation :embed
    end

    # decidim-core
    role.resource :component do |res|
      res.operation :read
    end

    # decidim-debates
    role.resource :debate do |res|
      res.operation :embed
      res.operation :read
    end

    # decidim-forms
    role.resource :questionnaire do |res|
      res.operation :answer
    end

    # decidim-meetings
    role.resource :meeting do |res|
      res.operation :embed
    end

    # decidim-participatory_processes
    role.resource :process do |res|
      res.operation :list
      res.operation :read
    end

    role.resource :process_group do |res|
      res.operation :list
      res.operation :read
    end

    role.resource :process_step do |res|
      res.operation :read
    end

    # should be `process` -> `list_public`
    role.resource :process_list do |res|
      res.operation :read
    end

    # decidim-proposals
    role.resource :proposal do |res|
      res.operation :embed
    end

    # decidim-sortitions
    role.resource :sortition do |res|
      res.operation :embed
      res.operation :read
    end
  end

  # === Collaborator role ===
  reg.role :collaborator do |role|
    role.resource :assembly_list do |res|
      res.operation :admin_read
    end

    role.resource :process_list do |res|
      res.operation :admin_read
    end

    role.resource :process do |res|
      res.operation :admin_preview
      res.operation :read
    end

    role.resource :participatory_space do |res|
      res.operation :read
    end

    role.resource :assembly do |res|
      res.operation :admin_read
      res.operation :admin_preview
    end

    role.resource :admin_dashboard do |res|
      res.operation :read
      res.operation :admin_read
    end

    role.resource :space_area do |res|
      res.operation :admin_enter
    end
  end

  # === Moderator role ===
  reg.role :moderator do |role|
    role.resource :assembly_list do |res|
      res.operation :admin_read
    end

    role.resource :process_list do |res|
      res.operation :admin_read
    end

      role.resource :participatory_space do |res|
        res.operation :read
        res.operation :admin_read
    end

    role.resource :admin_dashboard do |res|
      res.operation :read
      res.operation :admin_read
    end

    role.resource :space_area do |res|
      res.operation :admin_enter
    end

    role.resource :global_moderation do |res|
      res.operation :admin_read
    end

    role.resource :moderation do |res|
      res.operation :create
      res.operation :admin_read
      res.operation :admin_destroy
      res.operation :admin_block
      res.operation :admin_unreport
      res.operation :admin_hide
      res.operation :admin_unhide
    end

    role.resource :global_moderation do |res|
      res.operation :admin_destroy
      res.operation :admin_block
      res.operation :admin_read
      res.operation :admin_unreport
    end
  end
end

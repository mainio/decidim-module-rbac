# frozen_string_literal: true

module Decidim
  module RBAC
    module MeetingOverride
      extend ActiveSupport::Concern

      included do
        
      end
    end
  end
end


scope :visible_for, lambda { |user|
  if user.present?
    (spaces = Decidim.participatory_space_registry.manifests.filter_map do |manifest|
      table_name = manifest.model_class_name.constantize.try(:table_name)
      next if table_name.blank?

      {
        name: table_name.singularize,
        class_name: manifest.model_class_name
      }
    end)
    (user_role_queries = spaces.map do |space|
      roles_table = "#{space[:name]}_user_roles"
      next unless connection.table_exists?(roles_table)

      "SELECT decidim_components.id FROM decidim_components
      WHERE CONCAT(decidim_components.participatory_space_id, '-', decidim_components.participatory_space_type)
      IN
      (SELECT CONCAT(#{roles_table}.#{space[:name]}_id, '-#{space[:class_name]}')
      FROM #{roles_table} WHERE #{roles_table}.decidim_user_id = ?)
      "
    end)

    query = "
      decidim_meetings_meetings.private_meeting = ?
      OR decidim_meetings_meetings.transparent = ?
      OR decidim_meetings_meetings.id IN (
        SELECT decidim_meetings_registrations.decidim_meeting_id FROM decidim_meetings_registrations WHERE decidim_meetings_registrations.decidim_user_id = ?
      )
      OR decidim_meetings_meetings.decidim_component_id IN (
        SELECT decidim_components.id FROM decidim_components
        WHERE CONCAT(decidim_components.participatory_space_id, '-', decidim_components.participatory_space_type)
        IN
          (SELECT CONCAT(decidim_participatory_space_private_users.privatable_to_id, '-', decidim_participatory_space_private_users.privatable_to_type)
          FROM decidim_participatory_space_private_users WHERE decidim_participatory_space_private_users.decidim_user_id = ?)
      )
    "
    if user_role_queries.any?
      query = "#{query} OR decidim_meetings_meetings.decidim_component_id IN
        (#{user_role_queries.compact.join(" UNION ")})
      "
    end

    where(Arel.sql(query).to_s, false, true, user.id, user.id, *user_role_queries.compact.map { user.id }).published.distinct
  else
    published.visible
  end
}

def visible_for(user)
  return [] if !user.present?

  class_names = Decidim.participatory_space_registry.manifests.filter_map do |manifest|
    manifest.model_class_name if manifest.model_class_name.present?
  end
  spaces.map do |space|
    
  end
end
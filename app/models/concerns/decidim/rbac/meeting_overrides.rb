# frozen_string_literal: true

module Decidim
  module RBAC
    module MeetingOverrides
      extend ActiveSupport::Concern

      included do
        scope :visible_for, ->(user) do
          process_meetings = joins(:component)
                             .joins("INNER JOIN decidim_participatory_processes AS p
                                     ON p.id = decidim_components.participatory_space_id")
                             .where(decidim_components: { participatory_space_type: "Decidim::ParticipatoryProcess" })
                             .where.not(decidim_components: { published_at: nil })
                             .where.not(published_at: nil)
                             .where(p: { private_space: false })

          assembly_meetings = joins(:component)
                              .joins("INNER JOIN decidim_assemblies AS a
                                      ON a.id = decidim_components.participatory_space_id")
                              .where(decidim_components: { participatory_space_type: "Decidim::Assembly" })
                              .where.not(decidim_components: { published_at: nil })
                              .where.not(a: { published_at: nil })
                              .where(a: { private_space: false })

          public_meetings = where(id: process_meetings).or(where(id: assembly_meetings))

          return public_meetings.distinct unless user.present?

          process_special = joins(:component)
                            .joins("INNER JOIN decidim_participatory_processes AS p
                                    ON p.id = decidim_components.participatory_space_id")
                            .joins("INNER JOIN decidim_rbac_permission_role_assignments AS pra
                                    ON pra.record_type = 'Decidim::ParticipatorySpace'
                                    AND pra.record_id = p.id
                                    AND pra.subject_type = 'Decidim::User'
                                    AND pra.subject_id = #{user.id}
                                    AND pra.role IN ('process_admin','assembly_admin','private_user')")
                            .where(decidim_components: { participatory_space_type: "Decidim::ParticipatoryProcess" })

          assembly_special = joins(:component)
                             .joins("INNER JOIN decidim_assemblies AS a
                                     ON a.id = decidim_components.participatory_space_id")
                             .joins("INNER JOIN decidim_rbac_permission_role_assignments AS pra
                                     ON pra.record_type = 'Decidim::ParticipatorySpace'
                                     AND pra.record_id = a.id
                                     AND pra.subject_type = 'Decidim::User'
                                     AND pra.subject_id = #{user.id}
                                     AND pra.role IN ('process_admin','assembly_admin','private_user')")
                             .where(decidim_components: { participatory_space_type: "Decidim::Assembly" })

          special_meetings = where(id: process_special).or(where(id: assembly_special))

          where(id: public_meetings).or(where(id: special_meetings)).distinct
        end
      end
    end
  end
end

# frozen_string_literal: true

class CreateRbacTables < ActiveRecord::Migration[6.1]
  def change
    # create_table :decidim_rbac_permission_role do |t|
    #   t.string :key, null: false
    #   t.jsonb :permissions, null: false

    #   t.timestamps
    # end

    # The record has to be always defined even when the role assignment is not
    # specific to any record. In these cases, the record the role as assigned
    # against is the whole organization.
    #
    # The `resource` is the type of the resouce represented as a string, e.g.
    # "organization".
    create_table :decidim_rbac_permission_role_assignment do |t|
      t.string :role, null: false
      t.references :record, null: false, polymorphic: true, index: { name: "index_permission_role_assignment_on_record" }
      t.references :subject, polymorphic: true, index: { name: "index_permission_role_assignment_on_subject" }
      # t.references :role, null: false, foreign_key: { to_table: :decidim_rbac_permission_role }, index: { name: "index_permission_role_assignment_on_role" }
    end
  end
end

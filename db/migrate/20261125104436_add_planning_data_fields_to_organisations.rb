# frozen_string_literal: true

class AddPlanningDataFieldsToOrganisations < ActiveRecord::Migration[8.1]
  def change
    add_column :organisations, :reference, :string
    add_column :organisations, :local_planning_authority, :string
    add_column :organisations, :end_date, :date
    add_index :organisations, :reference, unique: true
  end
end

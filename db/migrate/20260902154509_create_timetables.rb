# frozen_string_literal: true

class CreateTimetables < ActiveRecord::Migration[8.1]
  def change
    create_table :timetables do |t|
      t.references :organisation, null: false, foreign_key: true, type: :bigint

      t.string :reference, null: false
      t.string :local_planning_authorities, null: false
      t.string :name, null: false
      t.string :dataset, null: false
      t.text :description, null: false
      t.string :period_start_date, null: false
      t.string :period_end_date, null: false
      t.string :documentation_url, null: false
      t.string :document_url, null: false
      t.date :entry_date, null: false
      t.integer :required_housing, null: false
      t.text :notes

      t.timestamps
    end
  end
end

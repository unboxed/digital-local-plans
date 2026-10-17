# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.references :organisation, null: false, foreign_key: true

      t.string :name
      t.string :reference
      t.string :dataset
      t.text :description
      t.text :notes
      t.string :status, null: false, default: "draft"

      t.string :document_url
      t.string :documentation_url
      t.string :local_planning_authorities
      t.integer :required_housing

      t.date :entry_date
      t.date :period_start_date
      t.date :period_end_date

      t.timestamps
    end

    add_index :plans, :status
  end
end

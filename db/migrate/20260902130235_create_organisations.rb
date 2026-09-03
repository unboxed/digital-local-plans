# frozen_string_literal: true

class CreateOrganisations < ActiveRecord::Migration[8.1]
  def change
    create_table :organisations do |t|
      t.string :name
      t.string :email, index: {unique: true}
      t.timestamps
    end
  end
end

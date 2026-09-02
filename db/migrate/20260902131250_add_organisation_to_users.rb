# frozen_string_literal: true

class AddOrganisationToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :organisation, null: true, foreign_key: true
  end
end

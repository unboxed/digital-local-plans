# frozen_string_literal: true

class CreateTimetableEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :timetable_events do |t|
      t.references :timetable, null: false, foreign_key: true, type: :bigint

      t.string :reference, null: false
      t.string :plan_event, null: false
      t.string :plan, null: false
      t.date :event_date, null: false
      t.date :actual_date
      t.date :entry_date, null: false
      t.text :notes

      t.timestamps
    end
  end
end

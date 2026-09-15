# db/migrate/YYYYMMDDHHMMSS_allow_drafts_on_timetables_and_events.rb
# frozen_string_literal: true

class AllowDraftsOnTimetablesAndEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :timetables, :status, :string, null: false, default: "draft"
    add_index :timetables, :status

    add_column :timetable_events, :status, :string, null: false, default: "draft"
    add_index :timetable_events, :status

    change_column_null :timetables, :dataset, true
    change_column_null :timetables, :description, true
    change_column_null :timetables, :document_url, true
    change_column_null :timetables, :documentation_url, true
    change_column_null :timetables, :entry_date, true
    change_column_null :timetables, :local_planning_authorities, true
    change_column_null :timetables, :name, true
    change_column_null :timetables, :period_end_date, true
    change_column_null :timetables, :period_start_date, true
    change_column_null :timetables, :reference, true
    change_column_null :timetables, :required_housing, true

    change_column_null :timetable_events, :entry_date, true
    change_column_null :timetable_events, :plan, true
    change_column_null :timetable_events, :plan_event, true
    change_column_null :timetable_events, :reference, true
  end
end

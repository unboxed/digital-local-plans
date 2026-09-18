# frozen_string_literal: true

class TimetablesChangeStringToDateForEndDateAndStartDate < ActiveRecord::Migration[8.1]
  def up
    change_column :timetables, :period_end_date, :date
    change_column :timetables, :period_start_date, :date
  end

  def down
    change_column :timetables, :period_end_date, :string
    change_column :timetables, :period_start_date, :string
  end
end

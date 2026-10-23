# frozen_string_literal: true

class ChangeTimetablePeriodDatesToYears < ActiveRecord::Migration[8.1]
  def change
    remove_column :timetables, :period_start_date, :date
    remove_column :timetables, :period_end_date, :date
    add_column :timetables, :period_start_year, :integer
    add_column :timetables, :period_end_year, :integer
  end
end

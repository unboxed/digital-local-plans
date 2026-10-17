# frozen_string_literal: true

class ChangePeriodDatesToYears < ActiveRecord::Migration[8.1]
  def up
    %i[timetables plans].each do |table|
      change_column table, :period_start_date, :integer, using: "EXTRACT(YEAR FROM period_start_date)::integer"
      change_column table, :period_end_date, :integer, using: "EXTRACT(YEAR FROM period_end_date)::integer"
    end
  end

  def down
    %i[timetables plans].each do |table|
      change_column table, :period_start_date, :date, using: "make_date(period_start_date, 1, 1)"
      change_column table, :period_end_date, :date, using: "make_date(period_end_date, 1, 1)"
    end
  end
end

class TimetablesChangeStringToDateForEndDateAndStartDate < ActiveRecord::Migration[8.1]
  def change
    change_column :timetables, :period_end_date, :date, 
                  using: 'period_end_date::date'
                    
    change_column :timetables, :period_start_date, :date, 
                  using: 'period_start_date::date'
  end
end

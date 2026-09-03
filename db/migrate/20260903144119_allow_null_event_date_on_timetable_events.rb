class AllowNullEventDateOnTimetableEvents < ActiveRecord::Migration[8.1]
  def change
    change_column_null :timetable_events, :event_date, true
  end
end

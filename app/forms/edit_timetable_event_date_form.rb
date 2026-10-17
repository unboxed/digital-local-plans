# frozen_string_literal: true

class EditTimetableEventDateForm
  include ActiveModel::Model
  include TimetableEventForm

  attr_accessor :selected_milestone_keyword, :event_date_day, :event_date_month, :event_date_year, :warnings_confirmed

  validate :validate_event_date
  validate :validate_future_and_max_dates

private

  def event_attributes
    { event_date: }
  end
end

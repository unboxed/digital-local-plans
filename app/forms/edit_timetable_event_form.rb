# frozen_string_literal: true

class EditTimetableEventForm
  include ActiveModel::Model
  include TimetableEventForm

  attr_accessor :event_date_day, :event_date_month, :event_date_year,
    :actual_date_day, :actual_date_month, :actual_date_year,
    :entry_date_day, :entry_date_month, :entry_date_year,
    :reference, :notes, :warnings_confirmed

  validates :reference, presence: true

  validate :validate_event_date
  validate :validate_future_and_max_dates

  def self.build_from_event(event)
    new(
      reference: event.reference,
      notes: event.notes,
      event_date_day: event.event_date&.day,
      event_date_month: event.event_date&.month,
      event_date_year: event.event_date&.year,
      actual_date_day: event.actual_date&.day,
      actual_date_month: event.actual_date&.month,
      actual_date_year: event.actual_date&.year,
      entry_date_day: event.entry_date&.day,
      entry_date_month: event.entry_date&.month,
      entry_date_year: event.entry_date&.year
    )
  end

  private

  def event_attributes
    {reference:, notes:, event_date:, actual_date:, entry_date:}
  end
end

# frozen_string_literal: true

class EditTimetableEventForm
  include ActiveModel::Model

  attr_accessor :event_date_day, :event_date_month, :event_date_year,
    :actual_date_day, :actual_date_month, :actual_date_year,
    :entry_date_day, :entry_date_month, :entry_date_year,
    :reference, :notes

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

  def save(event)
    return false if invalid?

    event.update!(
      reference:,
      notes:,
      event_date:,
      actual_date:,
      entry_date:
    )
  end

  def event_date
    parse_date(event_date_year, event_date_month, event_date_day)
  end

  def actual_date
    parse_date(actual_date_year, actual_date_month, actual_date_day)
  end

  def entry_date
    parse_date(entry_date_year, entry_date_month, entry_date_day)
  end

  private

  def parse_date(year, month, day)
    return nil if year.blank? || month.blank? || day.blank?

    Date.new(year.to_i, month.to_i, day.to_i)
  rescue ArgumentError
    nil
  end
end

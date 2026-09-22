# frozen_string_literal: true

class EditTimetableEventForm
  include ActiveModel::Model

  attr_accessor :event_date_day, :event_date_month, :event_date_year,
    :actual_date_day, :actual_date_month, :actual_date_year,
    :entry_date_day, :entry_date_month, :entry_date_year,
    :reference, :notes

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

  def save(event)
    return false if invalid?

    timetable_error_messages = []

    ActiveRecord::Base.transaction do
      event.update!(reference:, notes:, event_date:, actual_date:, entry_date:)

      timetable = event.timetable
      timetable.timetable_events.reload

      if timetable.invalid?
        relevant_errors = timetable.errors.where(:base).select do |error|
          error.options[:from_key] == event.plan_event || error.options[:to_key] == event.plan_event
        end

        if relevant_errors.any?
          timetable_error_messages = relevant_errors.map(&:message)
        end
      end
    end

    if timetable_error_messages.any?
      timetable_error_messages.each { |message| errors.add(:base, message) }
      return false
    end

    true
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

  private

  def validate_event_date
    if event_date_day.blank? || event_date_month.blank? || event_date_year.blank?
      errors.add(:event_date, :blank)
    elsif parse_date(event_date_year, event_date_month, event_date_day).nil?
      errors.add(:event_date, :invalid)
    end
  end

  def validate_future_and_max_dates
    date = event_date
    return unless date.is_a?(Date)

    if date < Date.current
      errors.add(:event_date, :not_in_future)
    end

    if date.year > 2050
      errors.add(:event_date, :too_far_in_future)
    end
  end
end

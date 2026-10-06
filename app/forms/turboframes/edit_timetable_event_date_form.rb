# frozen_string_literal: true

class Turboframes::EditTimetableEventDateForm
  include ActiveModel::Model

  attr_accessor :selected_milestone_keyword, :event_date_day, :event_date_month, :event_date_year

  validate :validate_event_date
  validate :validate_future_and_max_dates

  def save(event)
    return false if invalid?

    # TODO: Pass warnings/errors from Validator

    event.update!(
      event_date:
    )
  end

  def event_date
    parse_date(event_date_year, event_date_month, event_date_day)
  end

  private

  def parse_date(year, month, day)
    return nil if year.blank? || month.blank? || day.blank?

    Date.new(year.to_i, month.to_i, day.to_i)
  rescue ArgumentError
    nil
  end

  # Repeats from the other form, will see if I can share code between the two when refactoring
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

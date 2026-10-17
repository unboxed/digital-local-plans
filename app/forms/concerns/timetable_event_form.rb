# frozen_string_literal: true

module TimetableEventForm
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model

    attr_accessor :warnings_confirmed
  end

  def save(event)
    return false if invalid?

    ActiveRecord::Base.transaction do
      event.update!(event_attributes)

      timetable = event.timetable
      timetable.timetable_events.reload
      timetable.valid?

      timetable.errors.where(:base).each do |error|
        errors.add(:base, error.message) if relevant_to?(event, error.options)
      end
      @warnings = timetable.warnings.select { |warning| relevant_to?(event, warning.to_h) }.map(&:message)

      raise ActiveRecord::Rollback if blocked?
    end

    !blocked?
  end

  def warnings
    @warnings ||= []
  end

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

  def parse_date(year, month, day)
    return nil if year.blank? || month.blank? || day.blank?

    Date.new(year.to_i, month.to_i, day.to_i)
  rescue ArgumentError
    nil
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

  def event_attributes
    raise NotImplementedError, "#{self.class} must implement #event_attributes"
  end

  def blocked?
    errors.any? || (warnings.any? && warnings_confirmed != "true")
  end

  def relevant_to?(event, gap)
    gap[:from_key] == event.plan_event || gap[:to_key] == event.plan_event
  end
end

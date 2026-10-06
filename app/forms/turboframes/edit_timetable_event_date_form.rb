# frozen_string_literal: true

class Turboframes::EditTimetableEventDateForm
  include ActiveModel::Model

  attr_accessor :selected_milestone_keyword, :event_date_day, :event_date_month, :event_date_year

  def save(event)
    return false if invalid?

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
end

# frozen_string_literal: true

module ApplicationHelper
  def date_field_to_attribute(key)
    key.sub(/\(3i\)$/, "_day")
      .sub(/\(2i\)$/, "_month")
      .sub(/\(1i\)$/, "_year")
  end

  def plan_duration
    commencement = @timetable.timetable_events.find_by(plan_event: "gateway-1-self-assessment")
    adoption = @timetable.timetable_events.find_by(plan_event: "adopted")

    start_date = commencement&.event_date
    end_date = adoption&.event_date

    return unless start_date && end_date

    (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
  end
end

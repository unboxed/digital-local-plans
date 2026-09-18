# frozen_string_literal: true

class TimetableEventsController < ApplicationController
  before_action :set_timetable_event

  def edit
    @event_name = @timetable_event.plan_event.tr("-", " ").humanize
    @event_form = EditTimetableEventForm.build_from_event(@timetable_event)
  end

  def update
    @event_form = EditTimetableEventForm.new(timetable_event_params)

    if @event_form.save(@timetable_event)
      redirect_to timetables_path(current_organisation.current_timetable)
    else
      render :edit
    end
  end

  private

  def set_timetable_event
    @timetable_event = current_organisation.current_timetable.timetable_events.find(params[:id])
  end

  def timetable_event_params
    permitted = params.expect(
      edit_timetable_event_form: [
        :reference,
        :notes,
        :"event_date(1i)", :"event_date(2i)", :"event_date(3i)",
        :"actual_date(1i)", :"actual_date(2i)", :"actual_date(3i)",
        :"entry_date(1i)", :"entry_date(2i)", :"entry_date(3i)"
      ]
    )

    permitted.transform_keys do |key|
      key = date_field_to_attribute(key, "event_date")
      key = date_field_to_attribute(key, "actual_date")
      date_field_to_attribute(key, "entry_date")
    end
  end
end

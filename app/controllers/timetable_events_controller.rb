# frozen_string_literal: true

class TimetableEventsController < ApplicationController
  before_action :set_timetable_event

  def edit
    @event_name = @timetable_event.plan_event.tr("-", " ").humanize
    @event_form = EditTimetableEventForm.new
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
    params.expect(edit_timetable_event_form: %i[event_date actual_date entry_date])
  end
end

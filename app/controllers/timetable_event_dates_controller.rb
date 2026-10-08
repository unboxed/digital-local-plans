# frozen_string_literal: true

class TimetableEventDatesController < ApplicationController
  before_action :set_timetable

  def update
    @timetable_event_date_form = EditTimetableEventDateForm.new(timetable_event_date_params)

    if @timetable_event_date_form.valid?
      event = @timetable.timetable_events.find_or_initialize_by(
        plan_event: @timetable_event_date_form.selected_milestone_keyword
      )
    end

    if @timetable_event_date_form.save(event)
      flash[:success] = "#{TimetableEvent::REQUIRED_TIMETABLE_EVENTS.dig(event.plan_event, "name")} updated"
      redirect_to timetable_path(@timetable)
    else
      @status = TimetablesController::STATUSES.fetch(@timetable.status)
      @milestone_options = TimetableEvent::REQUIRED_TIMETABLE_EVENTS.map do |key, attributes|
        TimetablesController::MilestoneOption.new(id: key, name: attributes.fetch("name"))
      end
      render "timetables/show", status: :unprocessable_content
    end
  end

  def set_timetable
    # although we have current_timetable defined, it feels more sustainable to grab this from params
    @timetable = current_organisation.timetables.find(params[:timetable_id])
  end

  def timetable_event_date_params
    permitted = params.expect(
      edit_timetable_event_date_form: [
        :selected_milestone_keyword,
        :"event_date(1i)", :"event_date(2i)", :"event_date(3i)"
      ]
    )

    permitted.transform_keys { |key| date_field_to_attribute(key) }
  end
end

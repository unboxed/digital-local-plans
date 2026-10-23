# frozen_string_literal: true

class TimetablesController < ApplicationController
  before_action :set_timetable, only: %i[show edit update]
  before_action :redirect_if_timetable_exists, only: %i[new create]

  STATUSES = {
    "draft" => {text: "In progress", colour: "blue"}
  }.freeze

  def index
    if timetable = current_organisation.current_timetable
      redirect_to timetable_path(timetable)
    else
      redirect_to new_timetable_path
    end
  end

  def new
    @form = TimetableMetadataForm.new
  end

  def edit
    @form = TimetableMetadataForm.build_from_timetable(@timetable)
  end

  def show
    @status = status
    @plan_duration = plan_duration
  end

  def create
    @timetable = Timetable.new(organisation: current_organisation)
    @form = TimetableMetadataForm.new(timetable_metadata_params)

    if Timetables::CreateTimetableWithEvents.call(timetable: @timetable, form: @form)
      redirect_to home_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @form = TimetableMetadataForm.new(timetable_metadata_params)

    if @form.save(@timetable)
      redirect_to home_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def status
    STATUSES.fetch(@timetable.status)
  end

  def set_timetable
    @timetable = current_organisation.timetables.find(params[:id])
  end

  def redirect_if_timetable_exists
    timetable = current_organisation.current_timetable
    redirect_to timetable_path(timetable) if timetable
  end

  def timetable_metadata_params
    params.expect(timetable_metadata_form:
      [:reference, :name, :description, :period_start_year, :period_end_year,
        :documentation_url, :document_url, :notes])
  end
end

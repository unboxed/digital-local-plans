# frozen_string_literal: true

class TimetablesController < ApplicationController
  before_action :set_timetable, only: %i[show edit update]

  STATUSES = {
    "draft" => {text: "In progress", colour: "blue"}
  }.freeze

  def index
    timetable = current_organisation.current_timetable ||
      Timetables::InitializeTimetableWithEvents.call(organisation: current_user.organisation)

    redirect_to timetable_path(timetable)
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

    if @form.save(@timetable)
      redirect_to @timetable
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @form = TimetableMetadataForm.new(timetable_metadata_params)

    if @form.save(@timetable)
      redirect_to @timetable
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

  def timetable_metadata_params
    params.expect(timetable_metadata_form: 
      [:reference, :name, :description, :period_start_year, :period_end_year,
      :documentation_url, :document_url, :notes]
    )
  end
end

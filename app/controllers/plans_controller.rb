# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan

  def edit
    @plan_form = PlanMetadataForm.new
  end

  def update
  end

  private

  def set_plan
    @plan = current_organisation.plans.find(params[:id])
  end
end

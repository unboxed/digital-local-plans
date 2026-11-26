# frozen_string_literal: true

class ImportOrganisationsJob < ApplicationJob
  def perform
    Organisations::ImportFromPlanningData.call
  end
end

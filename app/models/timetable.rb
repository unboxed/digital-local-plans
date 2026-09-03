# frozen_string_literal: true

class Timetable < ApplicationRecord
  belongs_to :organisation
  has_many :timetable_events, dependent: :destroy

  validates :name, :local_planning_authorities, :dataset, :description,
    :period_start_date, :period_end_date, :documentation_url,
    :document_url, :entry_date, :required_housing, :reference, presence: true
end

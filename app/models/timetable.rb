# frozen_string_literal: true

class Timetable < ApplicationRecord
  before_validation { warnings.clear }

  belongs_to :organisation
  has_many :timetable_events, dependent: :destroy

  enum :status, {
    draft: "draft",
    published: "published"
  }, default: "draft"

  validates_with Timetables::MilestoneGapValidator, on: :update, unless: :draft?
  validates_with Timetables::MilestoneGapValidator, warning: true, on: :update, if: :draft?

  validates :status, presence: true

  with_options unless: :draft? do
    validates :name, :local_planning_authorities, :dataset, :description,
      :period_start_date, :period_end_date, :documentation_url,
      :document_url, :entry_date, :required_housing, :reference,
      presence: true
  end

  scope :upcoming, -> { where("period_end_date > ?", Date.current).order(:period_end_date) }

  def warnings
    @warnings ||= []
  end
end

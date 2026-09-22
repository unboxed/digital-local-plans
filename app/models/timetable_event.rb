# frozen_string_literal: true

class TimetableEvent < ApplicationRecord
  before_save :set_entry_date, unless: :new_record?

  belongs_to :timetable

  REQUIRED_TIMETABLE_EVENTS = YAML.load_file(
    Rails.root.join("config/required_timetable_events.yml")
  ).freeze

  TIMING_DESCRIPTIONS = {
    "public-notice-intention-commence" => "Must be published at least 4 months before Gateway 1.",
    "scoping-consultation-start" => "Must run for at least 21 days.",
    "scoping-consultation-end" => "Must be at least 21 days after the scoping consultation start.",
    "gateway-1-self-assessment" => "Marks formal commencement of the 30-month timeframe.",
    "plan-content-evidence-consultation-start" => "Must run for at least 6 weeks.",
    "plan-content-evidence-consultation-end" => "Must be at least 6 weeks after the consultation start date.",
    "gateway-2-advice-sought" => "Should take place between the content and proposed plan consultations.",
    "proposed-plan-consultation-start" => "Must run for at least 8 weeks.",
    "proposed-plan-consultation-end" => "Must be at least 8 weeks after the proposed plan consultation start date.",
    "gateway-3-advice-sought" => "Takes place after the proposed plan consultation closes, before submission.",
    "examination-submitted" => "Typically around 24 months after commencement (Gateway 1).",
    "adopted" => "Typically around 5-6 months after examination submission."
  }.freeze

  enum :status, {
    draft: "draft",
    published: "published"
  }, default: "draft"

  validates :status, presence: true
  validates :plan_event, presence: true

  with_options unless: :draft? do
    validates :reference, :entry_date, :plan, presence: true
  end

  def milestone_name
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "name")
  end

  def timing_description
    REQUIRED_TIMETABLE_EVENTS.dig(plan_event, "timing_description")
  end

  def set_entry_date
    self.entry_date = Date.current if (changed - ["entry_date"]).any?
  end
end

# frozen_string_literal: true

class TimetableEvent < ApplicationRecord
  belongs_to :timetable

  # Standard baseline event keys expected for every timetable
  REQUIRED_TIMETABLE_EVENTS = %w[
    public-notice-intention-commence
    scoping-consultation-start
    scoping-consultation-end
    gateway-1-self-assessment
    plan-content-evidence-consultation-start
    plan-content-evidence-consultation-end
    gateway-2-advice-sought
    proposed-plan-consultation-start
    proposed-plan-consultation-end
    gateway-3-advice-sought
    examination-submitted
    adopted
  ].freeze

  enum :status, {
    draft: "draft",
    published: "published"
  }, default: "draft"

  validates :status, presence: true
  validates :plan_event, presence: true

  with_options unless: :draft? do
    validates :reference, :entry_date, :plan, presence: true
  end
end

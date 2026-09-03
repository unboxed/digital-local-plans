# frozen_string_literal: true

class TimetableEvent < ApplicationRecord
  belongs_to :timetable

  TIMETABLE_EVENTS = %w[
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

  validates :plan_event, presence: true, inclusion: {in: TIMETABLE_EVENTS}

  validates :plan_event, :reference, :entry_date, presence: true
end

# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  delegate :govuk_link_to, to: :helpers

  def initialize(current_path: nil)
    @current_path = current_path
  end

  private

  attr_reader :current_path

  def active_link?(path)
    return false if current_path.blank?

    if path.start_with?("/timetables")
      current_path.start_with?("/timetables")
    else
      current_path == path
    end
  end
end

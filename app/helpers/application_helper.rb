# frozen_string_literal: true

module ApplicationHelper
  def date_field_to_attribute(key)
    key.sub(/\(3i\)$/, "_day")
      .sub(/\(2i\)$/, "_month")
      .sub(/\(1i\)$/, "_year")
  end
end

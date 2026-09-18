# frozen_string_literal: true

module ApplicationHelper
  def date_field_to_attribute(key, param_name)
    case key
    when "#{param_name}(3i)" then "#{param_name}_day"
    when "#{param_name}(2i)" then "#{param_name}_month"
    when "#{param_name}(1i)" then "#{param_name}_year"
    else key
    end
  end
end

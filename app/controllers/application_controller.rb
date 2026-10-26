# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include ApplicationHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_organisation
    current_user&.organisation
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      organisation_attributes: [:name]
    ])
  end
end

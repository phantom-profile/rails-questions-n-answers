# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
      format.html { redirect_to root_path, alert: exception.message, status: :forbidden }
      format.js { redirect_to root_path, alert: exception.message, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end

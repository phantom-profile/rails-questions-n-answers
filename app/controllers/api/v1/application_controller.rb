class Api::V1::ApplicationController < ApplicationController
  before_action :doorkeeper_authorize!
  protect_from_forgery with: :null_session

  protected

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end

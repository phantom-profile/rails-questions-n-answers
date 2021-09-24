class Api::V1::ProfilesController < Api::V1::ApplicationController
  authorize_resource class: false

  def me
    render json: current_user
  end

  def index
    @profiles = User.where.not(id: current_user.id)
    render json: @profiles
  end
end

# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    authorize!(:update, @link.linkable)

    @link.destroy
    redirect_back fallback_location: root_path
  end
end

# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    if current_user.author_of?(@link.linkable)
      @link.destroy
    end
    redirect_back fallback_location: root_path
  end
end

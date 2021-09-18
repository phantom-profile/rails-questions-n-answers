# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @resource = @file.record

    authorize! :update, @resource

    @file.purge
    redirect_back fallback_location: root_path
  end
end

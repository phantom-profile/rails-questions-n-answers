# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Blob.find_signed(params[:id])
    @resource = @file.attachments.first.record
    if current_user.author_of?(@resource)
      @file.attachments.first.purge
    end
    redirect_back fallback_location: root_path
  end
end

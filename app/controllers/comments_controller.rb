# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :send_to_channel, only: %i[create]

  def create
    @resource = resource_class.find(vote_params[:resource_id])
    @comment = @resource.comments.create({ user: current_user, body: vote_params[:body] })
  end

  private

  def resource_class
    vote_params[:resource].classify.constantize
  end

  def send_to_channel
    return unless @comment.valid?

    CommentsController.renderer.instance_variable_set(:@env, { 'warden' => warden })
    ActionCable.server.broadcast('comments_channel',
                                 { comment: CommentsController.render(
                                   partial: 'comments/comment',
                                   locals: { comment: @comment, current_user: nil }
                                 ),
                                   id: @resource.id })
  end

  def vote_params
    params.require(:comment).permit(:resource, :resource_id, :body)
  end
end

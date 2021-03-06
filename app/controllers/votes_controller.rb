# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @resource = resource_class.find(params[:resource_id])
    @vote = @resource.votes.build({ user: current_user, voted_for: params[:vote_for] })

    if @vote.save
      render json: { resource_id: @resource.id, rating: @resource.rating }
    else
      render json: { errors: @vote.errors.full_messages, rating: @resource.rating }
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @resource = @vote.votable

    authorize!(:destroy, @vote)

    @vote.destroy
    render json: { resource_id: @resource.id, rating: @resource.rating }
  end

  private

  def resource_class
    params[:resource].classify.constantize
  end

  def vote_params
    params.permit(:vote_for)
  end
end

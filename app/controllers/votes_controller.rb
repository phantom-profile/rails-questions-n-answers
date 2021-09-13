# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @resource = resource_class.find(params[:resource_id])
    @vote = Vote.find_or_initialize_by({ votable: @resource, user: current_user, voted_for: params[:vote_for] })

    if @vote.persisted? || current_user.author_of?(@resource)
      redirect_back(fallback_location: root_path)
      return
    end

    respond_to do |format|
      if @vote.save
        rating = @resource.votes.for(@resource).count - @resource.votes.against(@resource).count
        format.json do
          render json: { resource_id: @resource.id,
                         rating: rating }
        end
      end
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @resource = @vote.votable

    return unless current_user.author_of?(@vote)

    @vote.destroy
    respond_to do |format|
      rating = @resource.votes.for(@resource).count - @resource.votes.against(@resource).count
      format.json do
        render json: { resource_id: @resource.id,
                       rating: rating }
      end
    end
  end

  private

  def resource_class
    params[:resource].classify.constantize
  end

  def vote_params
    params.permit(:vote_for)
  end
end

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @resource = resource_class.find(params[:resource_id])
    @subscription = @resource.subscriptions.build({ user: current_user })

    if @subscription.save
      redirect_back fallback_location: root_path, notice: 'successfully subscribed'
    else
      redirect_back fallback_location: root_path, alert: @subscription.errors.full_messages
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @resource = @subscription.subscriptable

    authorize!(:destroy, @subscription)

    @subscription.destroy
    redirect_back fallback_location: root_path, notice: 'successfully unsubscribed'
  end

  private

  def resource_class
    params[:resource].classify.constantize
  end
end

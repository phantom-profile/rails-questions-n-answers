module IsSubscriptable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, as: :subscriptable, dependent: :destroy
    has_many :subscribers, class_name: 'User', through: :subscriptions, source: :user
  end

  def subscribed_by?(user)
    subscribers.include?(user)
  end

  def subscription_of(user)
    subscriptions.find_by(user: user)
  end
end
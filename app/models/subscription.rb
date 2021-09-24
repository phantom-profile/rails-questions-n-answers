class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscriptable, polymorphic: true

  validates_presence_of :subscriptable, :user
  validates :user, uniqueness: { scope: :subscriptable }
end

# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates_presence_of :votable, :user
  validates_inclusion_of :voted_for, in: [true, false]
  validates :user, uniqueness: { scope: :votable }
  validate :user_is_not_author_of_votable, on: :create

  scope :for, ->(votable) { where(votable: votable, voted_for: true) }
  scope :against, ->(votable) { where(votable: votable, voted_for: false) }

  def user_is_not_author_of_votable
    errors.add(:user, 'cannot vote your own resource') if user.author_of?(votable)
  end
end

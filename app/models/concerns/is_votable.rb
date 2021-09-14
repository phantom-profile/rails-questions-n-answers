# frozen_string_literal: true

module IsVotable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
    has_many :voted_users, class_name: 'User', through: :votes, source: :user
  end

  def voted_by?(user)
    voted_users.include?(user)
  end

  def vote_of(user)
    votes.find_by(user: user)
  end

  def rating
    votes.for(self).count - votes.against(self).count
  end
end

module IsVotable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
    has_many :voted_users, class_name: 'User', through: :votes, source: :user
  end
end

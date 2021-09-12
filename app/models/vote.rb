class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates_presence_of :votable, :user
  validates_inclusion_of :voted_for, in: [true, false]
  validates :user, uniqueness: { scope: :votable }

  scope :for, ->(votable) { where(votable: votable, voted_for: true) }
  scope :against, ->(votable) { where(votable: votable, voted_for: false) }
end

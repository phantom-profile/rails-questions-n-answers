# frozen_string_literal: true

class Question < ApplicationRecord
  include IsVotable

  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_one :reward, class_name: 'Reward', dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  scope :less_then_one_day_ago, -> { where('created_at >= ?', Time.zone.yesterday.beginning_of_day) }

  def choose_best_answer(answer, user)
    update!(best_answer: answer)
    return if reward.nil?

    ActiveRecord::Base.transaction do
      reward.update!(user: nil)
      user.rewards << reward
    end
  end
end

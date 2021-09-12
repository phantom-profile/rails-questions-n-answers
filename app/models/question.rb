# frozen_string_literal: true

class Question < ApplicationRecord
  include IsVotable

  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_one :reward, class_name: 'Reward', dependent: :destroy

  has_many_attached :files

  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank
  validates :title, :body, presence: true

  def choose_best_answer(answer, user)
    update!(best_answer: answer)
    return if reward.nil?

    ActiveRecord::Base.transaction do
      reward.update!(user: nil)
      user.rewards << reward
    end
  end
end

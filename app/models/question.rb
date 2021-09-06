# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_many_attached :files

  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true
  belongs_to :user

  validates :title, :body, presence: true
end

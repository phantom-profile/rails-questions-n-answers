class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  belongs_to :best_answer
  belongs_to :user

  has_many :comments
  has_many :answers
  has_many :links
  has_many :files
end

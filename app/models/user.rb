# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :answers
  has_many :questions
  has_many :rewards, dependent: :nullify

  has_many :votes, dependent: :destroy
  has_many :voted_answers, class_name: 'Answer', through: :votes, source: :answer

  def author_of?(resource)
    id == resource.user_id
  end
end

# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :answer, only: %i[update destroy choose_best]
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge({ user_id: current_user.id }))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def choose_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @question.update!(best_answer: @answer)
      if @question.reward.present?
        @reward = @question.reward
        @reward.update(user: nil)
        current_user.rewards << @reward
      end
    end
    @answers = @question.answers.without_best(@question.best_answer)
    @question = @answer.question
  end

  def delete_attachment
    @answer = Answer.find(params[:answer_id])
    if current_user.author_of?(@answer)
      @file = ActiveStorage::Blob.find_signed(params[:id])
      @file.attachments.first.purge
    end
    @question = @answer.question
    @answers = @question.answers.without_best(@question.best_answer)
  end

  private

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy], files: [])
  end
end

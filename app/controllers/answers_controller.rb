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
    @question.update!(best_answer: @answer) if current_user.author_of?(@question)
    @answers = @question.answers
    @question = @answer.question
  end

  private

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end

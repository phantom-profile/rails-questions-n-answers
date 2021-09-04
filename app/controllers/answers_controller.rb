# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge({ user_id: current_user.id }))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def choose_best
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @question.update(best_answer: @answer) if current_user.author_of?(@question)
    @answers = @question.answers
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def show
    @answer = Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Answer created successfully'
    else
      redirect_to question_path(@answer.question)
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user == @answer.user
      @answer.destroy
      redirect_to @answer.question, notice: 'answer deleted successfully'
    else
      redirect_to @answer.question, alert: 'It is not your answer'
    end
  end

  private

  def answer_params
    my_params = params.require(:answer).permit(:body)
    my_params[:user_id] = current_user.id
    my_params
  end
end

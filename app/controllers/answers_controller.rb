# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :question, only: %i[new create]
  before_action :answer, only: %i[show]

  def show; end

  def new; end

  def create
    @answer = question.answers.build(answer_params)
    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  private

  def answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question = Question.find(params[:question_id])
  end
end

# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :question
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
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end
end

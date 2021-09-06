# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :question, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params) if current_user.author_of?(@question)
    @questions = Question.all
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'question deleted successfully'
    else
      redirect_to questions_path, alert: 'it is not your question'
    end
  end

  private

  def question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end

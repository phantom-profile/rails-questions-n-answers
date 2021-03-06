# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :question, only: %i[show update destroy]
  before_action :authenticate_user!, except: %i[index show]

  after_action :send_to_channel, only: %i[create]

  authorize_resource

  def index
    @questions = Question.all.order(updated_at: :desc, created_at: :desc)
  end

  def show
    @answer = Answer.new
    @answer.links.build
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
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
    @question.update(question_params)
    @questions = Question.all
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'question deleted successfully'
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:id])
  end

  def send_to_channel
    return unless @question.persisted?

    QuestionsController.renderer.instance_variable_set(:@env, { 'warden' => warden })
    ActionCable.server.broadcast('questions_channel',
                                 QuestionsController.render(
                                   partial: 'questions/question',
                                   locals: { question: @question,
                                             current_user: nil }
                                 ))
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[id name url _destroy],
                                     files: [],
                                     reward_attributes: %i[title image])
  end
end

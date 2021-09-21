class Api::V1::AnswersController < Api::V1::ApplicationController
  authorize_resource

  before_action :answer, except: %i[index create]

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers.all
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge({ user_id: current_user.id }))
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy

    render json: @answer
  end

  private

  def answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url])
  end
end

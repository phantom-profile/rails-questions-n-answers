class Api::V1::QuestionsController < Api::V1::ApplicationController
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    render json: @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[id name url])
  end
end

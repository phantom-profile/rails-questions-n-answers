# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :answer, only: %i[update destroy choose_best]
  before_action :authenticate_user!

  after_action :send_to_channel, only: %i[create]

  authorize_resource except: [:choose_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge({ user_id: current_user.id }))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    @question = @answer.question
  end

  def choose_best
    @question = @answer.question

    authorize! :update, @question
    @question.choose_best_answer(@answer, current_user)

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

  def send_to_channel
    return unless @answer.persisted?

    AnswersController.renderer.instance_variable_set(:@env, { 'warden' => warden })
    ActionCable.server.broadcast('answers_channel',
                                 AnswersController.render(
                                   partial: 'answers/answer',
                                   locals: { answer: @answer,
                                             current_user: nil }
                                 ))
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy], files: [])
  end
end

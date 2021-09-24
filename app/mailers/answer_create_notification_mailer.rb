class AnswerCreateNotificationMailer < ApplicationMailer
  def fresh_answer(user, answer)
    @user = user
    @answer = answer
    @question = @resource.question
    mail to: @user.email
  end
end

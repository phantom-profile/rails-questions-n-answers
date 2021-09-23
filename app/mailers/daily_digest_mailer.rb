class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.less_then_one_day_ago
    mail to: @user.email
  end
end

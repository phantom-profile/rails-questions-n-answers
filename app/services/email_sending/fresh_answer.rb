class EmailSending::FreshAnswer
  def send_notification(users, answer)
    users.each do |user|
      AnswerCreateNotificationMailer.fresh_answer(user, answer).deliver_later
    end
  end
end

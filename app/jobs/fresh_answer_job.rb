class FreshAnswerJob < ApplicationJob
  queue_as :default

  def perform(users, answer)
    EmailSending::FreshAnswer.new.send_notification(users, answer)
  end
end

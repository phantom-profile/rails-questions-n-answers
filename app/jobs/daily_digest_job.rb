class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    EmailSending::DailyDigest.new.send_digest
  end
end

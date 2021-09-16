class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'questions_channel'
  end

  def receive(data)
    # reaction on receiving data from client
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

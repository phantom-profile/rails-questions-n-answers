import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    console.log('connection to AnswersChannel established')
  },

  disconnected() {
  },

  received(data) {
    console.log(data)
    $('.answers').append(data)
  }
});

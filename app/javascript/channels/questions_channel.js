import consumer from "./consumer"

consumer.subscriptions.create({channel: "QuestionsChannel", arg: 'arg'}, {
  connected() {
    console.log('connection to QuestionsChannel established')
  },

  disconnected() {
  },

  received(data) {
    $('.questions').append(data)
  }
});

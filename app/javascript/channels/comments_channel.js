import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    console.log('connection to CommentsChannel established')
  },

  disconnected() {
  },

  received(data) {
    $(`#${data.id}.comments`).append(data.comment)
  }
});

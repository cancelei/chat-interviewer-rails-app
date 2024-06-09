// app/javascript/channels/chat_channel.js
import consumer from "./consumer"

consumer.subscriptions.create("ChatChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const messages = document.getElementById("messages")
    messages.insertAdjacentHTML("beforeend", `<div class="message">${data.message}</div>`)
  }
})

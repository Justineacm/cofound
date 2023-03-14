import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { selectionId: Number, userId: Number }
  static targets = ["messages", "typing"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "SelectionChannel", id: this.selectionIdValue },
      { received: (data) => {
        if (data.typing) {
          if (data.user_id === this.userIdValue) { return };
          this.typingTarget.innerText = data.content

          setTimeout(() => {
            this.typingTarget.innerText = "";
          }, 1000);

        } else {
          this.#insertMessageAndScrollDown(data)
        }
      }}
    )
    // console.log(`Join your cofounder with the id ${this.selectionIdValue}.`)
  }

  resetForm(event) {
    event.target.reset()
  }

  disconnect() {
    console.log("You are leaving your cofounder's chatroom")
    this.channel.unsubscribe()
  }

  #insertMessageAndScrollDown(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  async isTyping(evt) {
    await fetch(`/selections/${this.selectionIdValue}/is_typing`);
  }
}

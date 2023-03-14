import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { selectionId: Number, currentUserId: Number }
  static targets = ["messages", "typing"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "SelectionChannel", id: this.selectionIdValue },
      { received: (data) => {
        if (data.typing) {
          if (data.user_id === this.currentUserIdValue) { return };
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
    const currentUserIsSender = this.currentUserIdValue === data.sender_id
    const messageElement = this.#buildMessageElement(currentUserIsSender, data.message)
    this.messagesTarget.insertAdjacentHTML("beforeend", messageElement)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  #buildMessageElement(currentUserIsSender, message) {
    return `
      <div class="message-row d-flex ${this.#justifyClass(currentUserIsSender)}">
        <div class="${this.#userStyleClass(currentUserIsSender)}">
          ${message}
        </div>
      </div>
    `
  }

  #justifyClass(currentUserIsSender) {
    return currentUserIsSender ? "justify-content-end" : "justify-content-start"
  }

  #userStyleClass(currentUserIsSender) {
    return currentUserIsSender ? "sender-style" : "receiver-style"
  }

  async isTyping(evt) {
    await fetch(`/selections/${this.selectionIdValue}/is_typing`);
  }
}

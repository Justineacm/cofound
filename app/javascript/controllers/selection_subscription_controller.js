import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { selectionId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "SelectionChannel", id: this.selectionIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    console.log(`Join your cofounder with the id ${this.selectionIdValue}.`)
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

}

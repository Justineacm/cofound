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


// const chatBox = document.getElementById("chatbox");
//     const chatBoxUserAvatar = document.getElementById("chatbox__user-avatar");
//     const chatBoxUserName = document.getElementById("chatbox__user-name");
//     const chatBoxClose = document.getElementById("chatbox__close");
//     const messageBottom = document.getElementById("message-bottom");
//     const messageContainer = document.getElementById("message__container");

//     window.openChatBox = (id, firt_name, photo) => {
//       if (id && first_name && photo && !isCurrentUser(selectedUser, selectedUid)) {
//         selectedUser = { id: selectedUid };
//         chatBox.classList.remove("hide");
//         chatBoxUserName.innerHTML = first_name;
//         chatBoxUserAvatar.src = photo;
//         messageContainer.innerHTML = '';
//         loadMessages();
//       }
//     }

//     if (chatBoxClose) {
//       chatBoxClose.addEventListener('click', function() {
//         messageContainer.innerHTML = '';
//         chatBox.classList.add("hide");
//         channel.removeMessageListener(selectedContact.uid);
//         selectedContact = null;
//       });
//     }

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="generate-matches"
export default class extends Controller {
  static targets = ["button", "cards"]

  connect() {
    console.log("Hello World!")
  }

  loader(event) {
    event.preventDefault()
    // let content = this.cardsTarget.value;
    // this.cardsTarget.innerHTML('afterbegin', content);
  }
}

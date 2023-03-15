import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="matchloader"
export default class extends Controller {
  static targets = ["submit"]
  connect() {
    console.log("hello")
  }

  submit(event) {
    // event.preventDefault()
    console.log("submit")
  }

}

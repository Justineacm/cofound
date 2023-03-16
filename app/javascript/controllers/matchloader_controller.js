import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="matchloader"
export default class extends Controller {
  static targets = ["submit", "loader", "form", "text"]
  connect() {
    console.log("hello")
  }

  submit(event) {
    event.preventDefault()
    this.loaderTarget.classList.remove("d-none")
    this.textTarget.classList.remove("d-none")
    setTimeout(() => {
      this.textTarget.innerHTML="Matching experiences"
    }, 1000);
    setTimeout(() => {
      this.textTarget.innerHTML="Matching MBTI profiles"
    }, 2000);
    setTimeout(() => {
      this.textTarget.innerHTML="Matching expertise"
    }, 3000);
    setTimeout(() => {
      this.textTarget.innerHTML="Matching locations"
    }, 4000);
    setTimeout(() => {
      this.formTarget.submit()
    }, 4500)
  }

}

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
      this.textTarget.innerHTML= '<span class="blue-color">Matching</span> <span class="orange-color">experiences</span>'
    }, 1000);
    setTimeout(() => {
      this.textTarget.innerHTML='<span class="blue-color">Matching</span> <span class="orange-color">MBTI profiles</span>'
    }, 2000);
    setTimeout(() => {
      this.textTarget.innerHTML='<span class="blue-color">Matching</span> <span class="orange-color">expertise</span>'
    }, 3000);
    setTimeout(() => {
      this.textTarget.innerHTML='<span class="blue-color">Matching</span> <span class="orange-color">locations</span>'
    }, 4000);
    setTimeout(() => {
      this.formTarget.submit()
    }, 4500)
  }

}

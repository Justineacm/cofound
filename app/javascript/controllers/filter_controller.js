import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["list", "form"]
  connect() {
  }

  submit(event) {
    const value = event.currentTarget.checked;
    const url = this.formTarget.action;
    fetch(`${url}?has_project=${value}`, {
      headers: {"Accept": "text/plain"}
    })
    .then(response => response.text())
    .then(data => {
      this.listTarget.innerHTML = data;
    })
  }
}

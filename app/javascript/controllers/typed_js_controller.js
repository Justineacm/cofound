import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

export default class extends Controller {
  connect() {
    new Typed(this.element, {
      strings: ["Your next cofounder", "One click away"],
      typeSpeed: 100,
      loop: true,
    })
  }
}

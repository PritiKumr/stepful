import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    document.addEventListener("click", this.closeIfClickedoutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeIfClickedoutside)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  closeIfClickedoutside(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden")
    }
  }
}

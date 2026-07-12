import { Controller } from "@hotwired/stimulus"

// Journal category filter. The chips live in the hero section (marked with
// [data-jrfilter-anchor]) while the cards are targets in this controller's
// scope, so chip clicks are bound manually on connect.
export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.chips = Array.from(document.querySelectorAll("[data-jrfilter-anchor] .jr-filter"))
    this.onChip = this.onChip.bind(this)
    this.chips.forEach((chip) => chip.addEventListener("click", this.onChip))
  }

  disconnect() {
    this.chips?.forEach((chip) => chip.removeEventListener("click", this.onChip))
  }

  onChip(event) {
    const chip = event.currentTarget
    const category = chip.dataset.category
    this.chips.forEach((c) => c.classList.toggle("is-active", c === chip))
    this.itemTargets.forEach((item) => {
      item.hidden = !(category === "all" || item.dataset.category === category)
    })
  }
}

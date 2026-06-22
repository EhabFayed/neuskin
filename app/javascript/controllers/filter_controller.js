import { Controller } from "@hotwired/stimulus"

// Protocols Hub "I'm here because…" filter. Shows protocol cards whose
// data-persona matches the chosen chip; "all" shows everything.
export default class extends Controller {
  static targets = ["item"]

  select(event) {
    const persona = event.params.persona

    // Toggle the active chip.
    this.element.querySelectorAll(".chip").forEach((chip) => {
      chip.classList.toggle("is-active", chip === event.currentTarget)
    })

    this.itemTargets.forEach((item) => {
      const show = persona === "all" || item.dataset.persona === persona
      item.hidden = !show
    })
  }
}

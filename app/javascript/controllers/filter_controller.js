import { Controller } from "@hotwired/stimulus"

// Protocols Hub "I'm here because…" filter. Shows protocol cards whose
// data-persona matches the chosen chip; "all" shows everything.
export default class extends Controller {
  static targets = ["item"]

  // If the URL carries ?persona=…, pre-apply that filter (homepage concern strip
  // links here) so the visitor lands already filtered to their concern.
  connect() {
    const persona = new URLSearchParams(window.location.search).get("persona")
    if (!persona) return
    const chip = this.element.querySelector(`.chip[data-filter-persona-param="${persona}"]`)
    if (chip) this.apply(persona, chip)
  }

  select(event) {
    this.apply(event.params.persona, event.currentTarget)
  }

  apply(persona, activeChip) {
    this.element.querySelectorAll(".chip").forEach((chip) => {
      chip.classList.toggle("is-active", chip === activeChip)
    })
    this.itemTargets.forEach((item) => {
      const show = persona === "all" || item.dataset.persona === persona
      item.hidden = !show
    })
  }
}

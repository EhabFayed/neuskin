import { Controller } from "@hotwired/stimulus"

// Tap / keyboard flip for .flipcard. Pointer devices already flip on hover
// (site-wide .flipcard CSS); this mirrors that with an .is-flipped class so
// the cards also work on touch screens and for keyboard users.
export default class extends Controller {
  toggle() {
    const flipped = this.element.classList.toggle("is-flipped")
    this.element.setAttribute("aria-pressed", flipped)
  }
}

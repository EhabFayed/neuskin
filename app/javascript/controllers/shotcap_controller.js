import { Controller } from "@hotwired/stimulus"

// Album photo caption toggle (The Clinic → "The Space"): the caption is
// hidden until the viewer presses the photo's "i" button; pressing again (or
// Escape) hides it. Pure class toggle — CSS does the reveal.
export default class extends Controller {
  static targets = ["button"]

  toggle() {
    const open = !this.element.classList.contains("is-open")
    this.element.classList.toggle("is-open", open)
    if (this.hasButtonTarget) this.buttonTarget.setAttribute("aria-expanded", String(open))
  }

  close() {
    this.element.classList.remove("is-open")
    if (this.hasButtonTarget) this.buttonTarget.setAttribute("aria-expanded", "false")
  }
}

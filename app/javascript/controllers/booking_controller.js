import { Controller } from "@hotwired/stimulus"

// Floating "Book" affordance: hidden at the top of the page (the hero already
// has its own CTA), then fades in once the visitor scrolls past the first
// viewport — present on every page without nagging above the fold.
export default class extends Controller {
  connect() {
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.onScroll()
  }

  disconnect() { window.removeEventListener("scroll", this.onScroll) }

  onScroll() {
    const past = window.scrollY > window.innerHeight * 0.8
    this.element.classList.toggle("is-visible", past)
  }
}

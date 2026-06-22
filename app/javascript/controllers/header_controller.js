import { Controller } from "@hotwired/stimulus"

// Adds .solid to the header once the page is scrolled past the hero edge.
export default class extends Controller {
  connect() {
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  onScroll() {
    this.element.classList.toggle("solid", window.scrollY > 40)
  }
}

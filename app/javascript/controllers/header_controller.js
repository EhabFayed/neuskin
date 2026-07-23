import { Controller } from "@hotwired/stimulus"

// Adds .solid to the header once the page is scrolled past the hero edge,
// and tucks the whole bar away (.is-tucked) while scrolling down — any
// scroll-up brings it back, and it never hides near the top of the page.
export default class extends Controller {
  connect() {
    this.lastY = window.scrollY
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  onScroll() {
    const y = window.scrollY
    this.element.classList.toggle("solid", y > 40)
    // 4px deadband so tiny jitters (rubber-banding, Lenis settle) don't flap it
    if (y < 140 || y < this.lastY - 4) {
      this.element.classList.remove("is-tucked")
    } else if (y > this.lastY + 4) {
      this.element.classList.add("is-tucked")
    }
    this.lastY = y
  }
}

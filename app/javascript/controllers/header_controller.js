import { Controller } from "@hotwired/stimulus"

// Adds .solid to the header once the page is scrolled past the hero edge.
export default class extends Controller {
  connect() {
    // Pages without a hero (everything but home) get a solid bar immediately;
    // the home hero keeps the header transparent until it is scrolled past.
    this.overHero = !!document.querySelector(".hero")
    this.element.classList.toggle("opaque", !this.overHero)
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  onScroll() {
    this.element.classList.toggle("solid", window.scrollY > 60)
  }
}

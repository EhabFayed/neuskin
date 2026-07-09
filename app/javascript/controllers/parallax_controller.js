import { Controller } from "@hotwired/stimulus"

// Gentle scroll parallax: nudges --py on each [data-parallax] descendant
// (or the element itself) based on its distance from viewport centre.
// data-parallax-speed-value scales the drift (default .12). Reduced-motion off.
export default class extends Controller {
  static values = { speed: { type: Number, default: 0.12 } }

  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    this.targets = this.element.matches("[data-parallax]")
      ? [this.element]
      : Array.from(this.element.querySelectorAll("[data-parallax]"))
    if (!this.targets.length) return

    this.ticking = false
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.update()
  }

  onScroll() {
    if (this.ticking) return
    this.ticking = true
    requestAnimationFrame(() => { this.update(); this.ticking = false })
  }

  update() {
    const vh = window.innerHeight
    this.targets.forEach((el) => {
      const rect = el.getBoundingClientRect()
      const speed = parseFloat(el.dataset.parallaxSpeed || this.speedValue)
      const fromCentre = (rect.top + rect.height / 2) - vh / 2
      el.style.setProperty("--py", `${(-fromCentre * speed).toFixed(1)}px`)
    })
  }

  disconnect() {
    if (this.onScroll) window.removeEventListener("scroll", this.onScroll)
  }
}

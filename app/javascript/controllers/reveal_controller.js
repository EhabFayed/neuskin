import { Controller } from "@hotwired/stimulus"

// Fades children up as they enter the viewport. Content is visible by default;
// this controller opts the section into the hide-then-reveal behaviour by adding
// .reveal-ready, so if JS never runs nothing stays hidden. Respects reduced-motion.
export default class extends Controller {
  static targets = ["item"]

  connect() {
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (reduce || !("IntersectionObserver" in window)) return

    this.element.classList.add("reveal-ready")

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("in")
            this.observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.12 }
    )

    this.itemTargets.forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}

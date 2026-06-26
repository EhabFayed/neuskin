import { Controller } from "@hotwired/stimulus"

// Reveals content as it enters the viewport. Two modes, both opt-in (the scope
// gets .reveal-ready so JS-off never hides anything; reduced-motion bails out):
//   1. Legacy: elements with class .reveal + data-reveal-target="item" get .in
//   2. Design vocabulary: any descendant with [data-reveal] (fade|up|left|scale|
//      mask) gets .is-in; per-element data-reveal-delay (ms) staggers it.
export default class extends Controller {
  static targets = ["item"]

  connect() {
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (reduce || !("IntersectionObserver" in window)) return

    this.element.classList.add("reveal-ready")

    // Collect both legacy items and design [data-reveal] nodes.
    const dataReveal = Array.from(this.element.querySelectorAll("[data-reveal]"))
    const legacy = this.itemTargets
    const watched = new Set([...legacy, ...dataReveal])

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return
          const el = entry.target
          const delay = parseInt(el.dataset.revealDelay || "0", 10)
          const base = 120
          setTimeout(() => {
            el.classList.add("in")     // legacy
            el.classList.add("is-in")  // design vocabulary
          }, base + delay)
          this.observer.unobserve(el)
        })
      },
      { threshold: 0.18, rootMargin: "0px 0px -10% 0px" }
    )

    watched.forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}

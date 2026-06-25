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

    // Small base delay so the motion begins a beat AFTER the section settles
    // into view, rather than the instant its edge appears. Feels intentional.
    const BASE_DELAY = 180 // ms

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const el = entry.target
            setTimeout(() => el.classList.add("in"), BASE_DELAY)
            this.observer.unobserve(el)
          }
        })
      },
      // threshold .25 + a negative bottom rootMargin => fires once the element
      // is genuinely within the viewport (the section has "appeared"), not while
      // it's still peeking in at the very bottom edge.
      { threshold: 0.25, rootMargin: "0px 0px -12% 0px" }
    )

    this.itemTargets.forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}

import { Controller } from "@hotwired/stimulus"

// Counts a number up to its target when it scrolls into view. Used for the
// bridal countdown and any "stat" numerals. Honors reduced-motion (jumps to
// final value). The target value is read from data-counter-to-value; the
// element's text is replaced with the animating number, optionally suffixed.
export default class extends Controller {
  static values = { to: Number, duration: { type: Number, default: 1100 }, suffix: { type: String, default: "" } }

  connect() {
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (reduce || !("IntersectionObserver" in window)) { this.render(this.toValue); return }

    this.done = false
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting && !this.done) { this.done = true; this.run() }
      })
    }, { threshold: 0.4 })
    this.observer.observe(this.element)
  }

  disconnect() { if (this.observer) this.observer.disconnect() }

  run() {
    const start = performance.now()
    const from = 0, to = this.toValue, dur = this.durationValue
    const ease = (t) => 1 - Math.pow(1 - t, 3) // easeOutCubic
    const tick = (now) => {
      const p = Math.min(1, (now - start) / dur)
      this.render(Math.round(from + (to - from) * ease(p)))
      if (p < 1) requestAnimationFrame(tick)
    }
    requestAnimationFrame(tick)
  }

  render(n) { this.element.textContent = `${n}${this.suffixValue}` }
}

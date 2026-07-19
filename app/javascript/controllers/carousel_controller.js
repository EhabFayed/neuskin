import { Controller } from "@hotwired/stimulus"

// Horizontal slide carousel (Seline-style "Our history"): full-width slides
// glide sideways; autoplays, pauses on hover/touch, arrows + dots navigate.
// RTL-aware (slides travel the reading direction). Reduced motion disables
// autoplay and the glide transition.
export default class extends Controller {
  static targets = ["track", "slide", "dot"]
  static values = { interval: { type: Number, default: 6000 } }

  connect() {
    this.index = 0
    this.dir = getComputedStyle(this.element).direction === "rtl" ? 1 : -1
    this.reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (this.reduce) this.trackTarget.style.transition = "none"
    this._render()
    this._play()
    this.element.addEventListener("mouseenter", () => this._stop())
    this.element.addEventListener("mouseleave", () => this._play())
    this.element.addEventListener("touchstart", () => this._stop(), { passive: true })
  }

  disconnect() { this._stop() }

  next() { this.go(this.index + 1) }
  prev() { this.go(this.index - 1) }

  // Dots pass their index via data-carousel-index-param
  jump(event) { this.go(parseInt(event.params.index, 10)) }

  go(i) {
    const n = this.slideTargets.length
    this.index = ((i % n) + n) % n
    this._render()
    this._stop(); this._play()
  }

  _render() {
    this.trackTarget.style.transform = `translateX(${this.dir * this.index * 100}%)`
    this.dotTargets.forEach((d, i) => d.classList.toggle("is-active", i === this.index))
    this.slideTargets.forEach((s, i) => s.setAttribute("aria-hidden", i === this.index ? "false" : "true"))
  }

  _play() {
    if (this.reduce || this.timer) return
    this.timer = setInterval(() => { this.index += 1; this._render() }, this.intervalValue)
  }

  _stop() {
    if (this.timer) { clearInterval(this.timer); this.timer = null }
  }
}

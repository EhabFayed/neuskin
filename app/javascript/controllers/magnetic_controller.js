import { Controller } from "@hotwired/stimulus"

// Magnetic pull: while hovered, the element leans a few px toward the
// pointer and springs back on leave. Uses the standalone `translate`
// property so it never clobbers transform-based show/hide animations
// (e.g. the floating book button). Fine pointers + motion-safe only.
export default class extends Controller {
  static values = { strength: { type: Number, default: 10 } }

  connect() {
    const fine = window.matchMedia("(pointer: fine)").matches
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (!fine || reduce) return

    this.element.classList.add("is-magnetic")
    this.onMove = (e) => {
      const r = this.element.getBoundingClientRect()
      const dx = (e.clientX - (r.left + r.width / 2)) / (r.width / 2)
      const dy = (e.clientY - (r.top + r.height / 2)) / (r.height / 2)
      this.element.style.translate = `${dx * this.strengthValue}px ${dy * this.strengthValue}px`
    }
    this.onLeave = () => { this.element.style.translate = "0px 0px" }

    this.element.addEventListener("pointermove", this.onMove, { passive: true })
    this.element.addEventListener("pointerleave", this.onLeave, { passive: true })
  }

  disconnect() {
    this.element.removeEventListener("pointermove", this.onMove)
    this.element.removeEventListener("pointerleave", this.onLeave)
    this.element.classList.remove("is-magnetic")
    this.element.style.translate = ""
  }
}

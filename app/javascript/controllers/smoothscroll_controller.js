import { Controller } from "@hotwired/stimulus"
import Lenis from "lenis"

// Buttery inertia scrolling (Lenis, vendored). Mounted on <body> so Turbo
// navigations tear it down and rebuild it cleanly. Native scrolling stays
// for touch devices and under reduced motion — Lenis only smooths the wheel.
export default class extends Controller {
  connect() {
    const fine = window.matchMedia("(pointer: fine)").matches
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (!fine || reduce) return

    // long, feather-soft glide — each wheel tick eases out over ~1.8s
    this.lenis = new Lenis({
      autoRaf: true,
      duration: 1.8,
      easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
      smoothWheel: true,
    })
  }

  disconnect() {
    this.lenis?.destroy()
    this.lenis = null
  }
}

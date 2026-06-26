import { Controller } from "@hotwired/stimulus"

// Pinned horizontal gallery: as the user scrolls vertically through this tall
// section, translate the inner track sideways so the photos move past. The
// scroll distance available = section height − viewport; the track travels its
// full overflow width across that distance. On mobile the CSS disables pinning
// and this controller no-ops (track has no transform to set).
export default class extends Controller {
  static targets = ["track"]

  connect() {
    this.mobile = window.matchMedia("(max-width: 880px)").matches
    if (this.mobile || !this.hasTrackTarget) return

    this.onScroll = this.onScroll.bind(this)
    this.onResize = this.onResize.bind(this)
    this.measure()
    window.addEventListener("scroll", this.onScroll, { passive: true })
    window.addEventListener("resize", this.onResize, { passive: true })
    this.update()
  }

  measure() {
    // How far the track must travel so its end aligns with the viewport's right edge.
    this.maxX = Math.max(0, this.trackTarget.scrollWidth - window.innerWidth)
  }

  onResize() {
    if (window.matchMedia("(max-width: 880px)").matches) {
      this.trackTarget.style.transform = ""
      return
    }
    this.measure()
    this.update()
  }

  onScroll() {
    if (this.ticking) return
    this.ticking = true
    requestAnimationFrame(() => { this.update(); this.ticking = false })
  }

  update() {
    const rect = this.element.getBoundingClientRect()
    const scrollable = this.element.offsetHeight - window.innerHeight
    if (scrollable <= 0) return
    // Progress 0→1 across the time the section is pinned.
    const progress = Math.min(1, Math.max(0, -rect.top / scrollable))
    this.trackTarget.style.transform = `translate3d(${-(progress * this.maxX).toFixed(1)}px,0,0)`
  }

  disconnect() {
    if (this.onScroll) window.removeEventListener("scroll", this.onScroll)
    if (this.onResize) window.removeEventListener("resize", this.onResize)
  }
}

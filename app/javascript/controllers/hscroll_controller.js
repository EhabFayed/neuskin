import { Controller } from "@hotwired/stimulus"

// Pinned horizontal gallery: as the user scrolls vertically through this tall
// section, translate the inner track sideways so the photos move past.
//
// On mobile (<=880px, matching the CSS breakpoint) the section is stacked
// vertically by CSS and this effect MUST NOT run — otherwise a stale transform
// makes the section jump/move on scroll. We therefore check the breakpoint
// LIVE on every update (not once at connect), and actively clear the transform
// whenever we're at mobile width, so rotation / responsive-mode / late layout
// can never leave a lingering transform.
export default class extends Controller {
  static targets = ["track"]

  connect() {
    if (!this.hasTrackTarget) return
    this.mq = window.matchMedia("(max-width: 880px)")
    this.onScroll = this.onScroll.bind(this)
    this.onResize = this.onResize.bind(this)
    this.measure()
    window.addEventListener("scroll", this.onScroll, { passive: true })
    window.addEventListener("resize", this.onResize, { passive: true })
    this.update()
  }

  get isMobile() {
    return this.mq ? this.mq.matches : window.innerWidth <= 880
  }

  clear() {
    if (this.trackTarget.style.transform) this.trackTarget.style.transform = ""
  }

  measure() {
    this.maxX = Math.max(0, this.trackTarget.scrollWidth - window.innerWidth)
  }

  onResize() {
    if (this.isMobile) { this.clear(); return }
    this.measure()
    this.update()
  }

  onScroll() {
    if (this.ticking) return
    this.ticking = true
    requestAnimationFrame(() => { this.update(); this.ticking = false })
  }

  update() {
    // Live breakpoint check every frame — never trust a latched value.
    if (this.isMobile) { this.clear(); return }

    const rect = this.element.getBoundingClientRect()
    const scrollable = this.element.offsetHeight - window.innerHeight
    if (scrollable <= 0) return
    const progress = Math.min(1, Math.max(0, -rect.top / scrollable))
    // In RTL the track overflows to the LEFT of the pin, so translate rightward.
    const rtl = getComputedStyle(this.trackTarget).direction === "rtl"
    const x = (progress * this.maxX * (rtl ? 1 : -1)).toFixed(1)
    this.trackTarget.style.transform = `translate3d(${x}px,0,0)`
  }

  disconnect() {
    if (this.onScroll) window.removeEventListener("scroll", this.onScroll)
    if (this.onResize) window.removeEventListener("resize", this.onResize)
  }
}

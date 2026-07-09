import { Controller } from "@hotwired/stimulus"

// Full-screen NS monogram splash that fades out shortly after first load.
// Shows once per browser session (sessionStorage), respects reduced-motion,
// and never traps the page (it's removed from the flow once done).
const KEY = "neuskin-intro-seen"

export default class extends Controller {
  connect() {
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    const seen = (() => { try { return sessionStorage.getItem(KEY) } catch (e) { return null } })()

    if (reduce || seen) {
      this.dismiss(0)
      return
    }
    // Hold the splash briefly so the intro animation plays, then fade out.
    this.timer = setTimeout(() => this.dismiss(), 1700)
  }

  dismiss(_) {
    this.element.classList.add("is-done")
    try { sessionStorage.setItem(KEY, "1") } catch (e) { /* private mode */ }
    // Remove after the fade so it can't intercept clicks.
    setTimeout(() => { if (this.element.parentNode) this.element.remove() }, 850)
  }

  disconnect() {
    if (this.timer) clearTimeout(this.timer)
  }
}

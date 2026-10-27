import { Controller } from "@hotwired/stimulus"

// NeuSkin Digital Gift Card (/promo): a closed envelope; tapping the seal
// opens it (crossfade to the open photograph), the card copy rises in, then
// the reserve button + code appear beneath. "Close the envelope" resets.
// As in the concept prototype, the envelope opens by itself after a pause
// if the visitor hasn't tapped — nobody should leave without seeing the gift.
export default class extends Controller {
  static targets = ["scene", "seal", "hint", "act"]
  static values = {
    claimUrl: String,
    autoOpenDelay: { type: Number, default: 3200 }
  }

  connect() {
    this.reduceMotion = window.matchMedia && matchMedia("(prefers-reduced-motion: reduce)").matches
    this.autoOpen = setTimeout(() => this.open(), this.autoOpenDelayValue)
  }

  disconnect() {
    clearTimeout(this.autoOpen)
    clearTimeout(this.showAct)
  }

  open() {
    clearTimeout(this.autoOpen)
    if (this.sceneTarget.classList.contains("is-open")) return
    this.sceneTarget.classList.add("is-open")
    this.sealTarget.setAttribute("aria-label", this.sealTarget.dataset.openedLabel || "")
    this.sealTarget.disabled = true
    this.hintTarget.classList.add("is-hidden")
    // The card copy has risen by ~1.3s (see .rise delays); then the actions.
    this.showAct = setTimeout(() => {
      this.actTarget.classList.add("is-shown")
      this.actTarget.setAttribute("aria-hidden", "false")
    }, this.reduceMotion ? 0 : 1500)
  }

  close() {
    clearTimeout(this.showAct)
    this.actTarget.classList.remove("is-shown")
    this.actTarget.setAttribute("aria-hidden", "true")
    this.sceneTarget.classList.remove("is-open")
    this.sealTarget.disabled = false
    this.hintTarget.classList.remove("is-hidden")
  }

  // One tap on the reserve button = one use. Fire-and-forget beacon; the
  // WhatsApp link opens whether or not the count lands.
  claim() {
    if (!this.claimUrlValue) return
    const token = document.querySelector("meta[name='csrf-token']")?.content
    const headers = { Accept: "application/json" }
    if (token) headers["X-CSRF-Token"] = token
    try {
      fetch(this.claimUrlValue, { method: "POST", keepalive: true, headers }).catch(() => {})
    } catch (_) { /* counting is best-effort */ }
  }
}

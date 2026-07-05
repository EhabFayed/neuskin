import { Controller } from "@hotwired/stimulus"

// Live preview for the admin section editor.
// Renders the REAL public page (live site CSS) with the editor's UNSAVED
// values inside an iframe, updating on a debounce as you type. The editor can
// switch the preview width (mobile / tablet / laptop presets, or drag) — the
// iframe renders at that CSS width (so real breakpoints apply) and is scaled
// to fit the panel.
export default class extends Controller {
  static targets = [
    "frame", "loading", "pickedwrap", "pickedimg",
    "stage", "viewport", "handle", "widthLabel",
  ]
  static values = { url: String }

  connect() {
    this.form = this.element
    this.onInput = this.onInput.bind(this)
    this.onResize = this.applyWidth.bind(this)
    this.element.addEventListener("input", this.onInput)
    window.addEventListener("resize", this.onResize)

    this.deviceWidth = 390 // default: mobile
    this.applyWidth()
    this.refresh()
  }

  disconnect() {
    this.element.removeEventListener("input", this.onInput)
    window.removeEventListener("resize", this.onResize)
    if (this.timer) clearTimeout(this.timer)
  }

  // ---- viewport width control ----

  setDevice(event) {
    const w = parseInt(event.currentTarget.dataset.width, 10)
    if (w) { this.deviceWidth = w; this.applyWidth(); this.markActive(w) }
  }

  markActive(w) {
    this.element.querySelectorAll(".lp-dev").forEach((b) => {
      b.classList.toggle("on", parseInt(b.dataset.width, 10) === w)
    })
  }

  // Render the iframe at deviceWidth CSS px, then scale the whole viewport down
  // to fit the available stage width so the full page width is always visible.
  applyWidth() {
    if (!this.hasStageTarget || !this.hasViewportTarget) return
    const w = this.deviceWidth
    const stageW = this.stageTarget.clientWidth - 2
    const scale = Math.min(1, stageW / w)
    const fh = this.hasFrameTarget ? this.frameTarget : null

    this.viewportTarget.style.width = w + "px"
    this.viewportTarget.style.transform = `scale(${scale})`
    this.viewportTarget.style.transformOrigin = "top left"
    // reserve the scaled height in the stage
    const vpH = this.viewportTarget.offsetHeight || 700
    this.stageTarget.style.height = (vpH * scale) + "px"
    if (fh) fh.style.width = w + "px"
    if (this.hasWidthLabelTarget) this.widthLabelTarget.textContent = w + "px"
  }

  startDrag(event) {
    event.preventDefault()
    const startX = event.clientX
    const startW = this.deviceWidth
    const move = (e) => {
      // dragging right widens; clamp to a sane range
      const delta = (e.clientX - startX) * 2 // handle sits on the right edge of a scaled box
      this.deviceWidth = Math.max(320, Math.min(1600, Math.round(startW + delta)))
      this.applyWidth()
      this.markActive(this.deviceWidth)
    }
    const up = () => {
      document.removeEventListener("mousemove", move)
      document.removeEventListener("mouseup", up)
    }
    document.addEventListener("mousemove", move)
    document.addEventListener("mouseup", up)
  }

  // ---- content refresh ----

  onInput() {
    if (this.timer) clearTimeout(this.timer)
    this.timer = setTimeout(() => this.refresh(), 400)
  }

  async refresh() {
    if (!this.hasFrameTarget || !this.urlValue) return
    if (this.hasLoadingTarget) this.loadingTarget.classList.add("on")
    try {
      const fd = new FormData(this.form)
      fd.delete("_method")
      const token = document.querySelector('meta[name="csrf-token"]')?.content
      const res = await fetch(this.urlValue, {
        method: "POST", body: fd,
        headers: token ? { "X-CSRF-Token": token } : {},
        credentials: "same-origin",
      })
      if (res.ok) {
        this.frameTarget.srcdoc = await res.text()
        // re-fit after the new document lays out
        this.frameTarget.addEventListener("load", () => this.applyWidth(), { once: true })
      }
    } catch (e) {
      // keep the last good preview
    } finally {
      if (this.hasLoadingTarget) this.loadingTarget.classList.remove("on")
    }
  }

  pickImage(event) {
    const file = event.target.files && event.target.files[0]
    if (!file || !this.hasPickedwrapTarget) return
    const reader = new FileReader()
    reader.onload = (e) => {
      this.pickedimgTarget.src = e.target.result
      this.pickedwrapTarget.hidden = false
    }
    reader.readAsDataURL(file)
  }
}

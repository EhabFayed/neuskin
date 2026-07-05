import { Controller } from "@hotwired/stimulus"

// Live preview for the admin section editor.
// Renders the REAL public page (styled with the live site CSS) with the
// editor's UNSAVED values, inside an iframe — updating on a debounce as you
// type. Also previews a just-picked image thumbnail before it's uploaded.
export default class extends Controller {
  static targets = ["frame", "loading", "pickedwrap", "pickedimg"]
  static values = { url: String }

  connect() {
    this.form = this.element // the form carries the controller
    this.onInput = this.onInput.bind(this)
    this.element.addEventListener("input", this.onInput)
    this.refresh() // initial render
  }

  disconnect() {
    this.element.removeEventListener("input", this.onInput)
    if (this.timer) clearTimeout(this.timer)
  }

  onInput() {
    if (this.timer) clearTimeout(this.timer)
    this.timer = setTimeout(() => this.refresh(), 400)
  }

  async refresh() {
    if (!this.hasFrameTarget || !this.urlValue) return
    if (this.hasLoadingTarget) this.loadingTarget.classList.add("on")
    try {
      const fd = new FormData(this.form)
      fd.delete("_method") // this is a preview POST, not the update PATCH
      const token = document.querySelector('meta[name="csrf-token"]')?.content
      const res = await fetch(this.urlValue, {
        method: "POST",
        body: fd,
        headers: token ? { "X-CSRF-Token": token } : {},
        credentials: "same-origin",
      })
      if (res.ok) {
        this.frameTarget.srcdoc = await res.text()
      }
    } catch (e) {
      // leave the last good preview in place
    } finally {
      if (this.hasLoadingTarget) this.loadingTarget.classList.remove("on")
    }
  }

  // Client-side preview of a just-picked image (before it's uploaded on save).
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

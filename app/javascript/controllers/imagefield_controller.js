import { Controller } from "@hotwired/stimulus"

// Studio image field: shows the current upload as a thumbnail, previews a
// newly picked file before saving, and offers Remove / Undo. "Remove" only
// flips a hidden flag (…[remove_x]=1) — the controller purges on Save, so
// nothing is deleted until the editor actually saves the form.
export default class extends Controller {
  static targets = ["input", "preview", "empty", "badge", "remove", "undo", "flag", "filename", "label", "frame"]

  connect() {
    this.originalUrl = this.previewTarget.getAttribute("src") || ""
    this.originalName = this.hasFilenameTarget ? this.filenameTarget.textContent : ""
    this.objectUrl = null
  }

  disconnect() { this.revoke() }

  pick() {
    const files = Array.from(this.inputTarget.files || [])
    if (!files.length) return
    this.revoke()
    this.objectUrl = URL.createObjectURL(files[0])
    this.previewTarget.src = this.objectUrl
    this.previewTarget.hidden = false
    this.emptyTarget.hidden = true
    this.frameTarget.classList.remove("is-removing", "is-empty")
    this.setFlag("0")
    this.badge(files.length > 1 ? `${files.length} images selected — saved on Save` : "New — saved on Save")
    if (this.hasFilenameTarget) this.filenameTarget.textContent = files.map((f) => f.name).join(", ")
    if (this.hasRemoveTarget) this.removeTarget.hidden = true
    this.undoTarget.hidden = false
  }

  remove() {
    this.setFlag("1")
    this.previewTarget.hidden = true
    this.emptyTarget.hidden = false
    this.emptyTarget.textContent = "Removed — saved on Save"
    this.frameTarget.classList.add("is-removing")
    this.badge("")
    if (this.hasRemoveTarget) this.removeTarget.hidden = true
    this.undoTarget.hidden = false
  }

  undo() {
    this.revoke()
    this.inputTarget.value = ""
    this.setFlag("0")
    this.frameTarget.classList.remove("is-removing")
    if (this.originalUrl) {
      this.previewTarget.src = this.originalUrl
      this.previewTarget.hidden = false
      this.emptyTarget.hidden = true
      this.frameTarget.classList.remove("is-empty")
      if (this.hasRemoveTarget && this.hasFlagTarget) this.removeTarget.hidden = false
    } else {
      this.previewTarget.removeAttribute("src")
      this.previewTarget.hidden = true
      this.emptyTarget.hidden = false
      this.emptyTarget.textContent = "No image"
      this.frameTarget.classList.add("is-empty")
    }
    if (this.hasFilenameTarget) this.filenameTarget.textContent = this.originalName
    this.badge("")
    this.undoTarget.hidden = true
  }

  setFlag(v) { if (this.hasFlagTarget) this.flagTarget.value = v }
  badge(text) { this.badgeTarget.textContent = text; this.badgeTarget.hidden = !text }
  revoke() { if (this.objectUrl) { URL.revokeObjectURL(this.objectUrl); this.objectUrl = null } }
}

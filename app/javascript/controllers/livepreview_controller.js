import { Controller } from "@hotwired/stimulus"

// Live preview for the admin section editor.
// Mirrors the section's IMAGE (current attachment, or a just-picked upload —
// read client-side before saving) plus every EN/AR field value into a styled
// preview panel that updates as the editor types or chooses a file.
//
// Markup contract:
//   data-controller="livepreview"
//   optional <img data-livepreview-target="img"> seeded with the current image
//   optional <input type=file data-livepreview-target="file" data-action="livepreview#pickImage">
//   each editable row: data-livepreview-target="row" data-field-label="Headline"
//     with <textarea data-lang="en"> and <textarea data-lang="ar">
//   the panel: data-livepreview-target="out"
export default class extends Controller {
  static targets = ["row", "out", "img", "file"]

  connect() {
    this.render = this.render.bind(this)
    this.element.addEventListener("input", this.render)
    this.render()
  }

  disconnect() {
    this.element.removeEventListener("input", this.render)
  }

  // When the editor picks a new image file, read it locally and preview it
  // immediately — before any save/upload.
  pickImage(event) {
    const file = event.target.files && event.target.files[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = (e) => { this.pickedImageUrl = e.target.result; this.render() }
    reader.readAsDataURL(file)
  }

  currentImageUrl() {
    if (this.pickedImageUrl) return this.pickedImageUrl
    if (this.hasImgTarget && this.imgTarget.dataset.url) return this.imgTarget.dataset.url
    return null
  }

  render() {
    let html = ""

    const imgUrl = this.currentImageUrl()
    if (imgUrl) {
      html += `<div class="lp-imgwrap"><img class="lp-img" src="${this.esc(imgUrl)}" alt=""></div>`
    }

    const blocks = this.rowTargets.map((row) => {
      const label = row.dataset.fieldLabel || ""
      const en = (row.querySelector('[data-lang="en"]')?.value || "").trim()
      const ar = (row.querySelector('[data-lang="ar"]')?.value || "").trim()
      const isHeading = /headline|title|heading|quote/i.test(label)
      const cls = isHeading ? "lp-heading" : "lp-text"

      const enHtml = en
        ? `<div class="${cls}">${this.esc(en)}</div>`
        : `<div class="lp-empty">— ${this.esc(label)} (empty)</div>`
      const arHtml = ar ? `<div class="${cls} lp-ar" dir="rtl">${this.esc(ar)}</div>` : ""

      return `<div class="lp-block"><div class="lp-lbl">${this.esc(label)}</div>${enHtml}${arHtml}</div>`
    })

    html += blocks.join("")
    this.outTarget.innerHTML = html || '<div class="lp-empty">Nothing to preview yet.</div>'
  }

  esc(s) {
    const d = document.createElement("div")
    d.textContent = s
    return d.innerHTML
  }
}

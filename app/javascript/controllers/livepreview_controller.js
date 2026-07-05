import { Controller } from "@hotwired/stimulus"

// Live preview for the admin section editor.
// Watches every EN/AR field in the form and mirrors the current (unsaved)
// values into a styled preview panel that updates as the editor types.
//
// Markup contract:
//   data-controller="livepreview"
//   each editable row: data-livepreview-target="row"
//     with data-field-label="Headline"
//     containing <textarea data-lang="en"> and <textarea data-lang="ar">
//   the panel:  data-livepreview-target="out"
export default class extends Controller {
  static targets = ["row", "out"]

  connect() {
    this.render = this.render.bind(this)
    this.element.addEventListener("input", this.render)
    this.render()
  }

  disconnect() {
    this.element.removeEventListener("input", this.render)
  }

  render() {
    const blocks = this.rowTargets.map((row) => {
      const label = row.dataset.fieldLabel || ""
      const en = (row.querySelector('[data-lang="en"]')?.value || "").trim()
      const ar = (row.querySelector('[data-lang="ar"]')?.value || "").trim()
      const isHeading = /headline|title|heading|quote/i.test(label)
      const cls = isHeading ? "lp-heading" : "lp-text"

      const enHtml = en
        ? `<div class="${cls}">${this.esc(en)}</div>`
        : `<div class="lp-empty">— ${this.esc(label)} (empty)</div>`
      const arHtml = ar
        ? `<div class="${cls} lp-ar" dir="rtl">${this.esc(ar)}</div>`
        : ""

      return `<div class="lp-block"><div class="lp-lbl">${this.esc(label)}</div>${enHtml}${arHtml}</div>`
    })
    this.outTarget.innerHTML = blocks.join("") || '<div class="lp-empty">Nothing to preview yet.</div>'
  }

  esc(s) {
    const d = document.createElement("div")
    d.textContent = s
    return d.innerHTML
  }
}

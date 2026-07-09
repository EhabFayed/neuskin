import { Controller } from "@hotwired/stimulus"

// Home "Six Protocols": hovering (or focusing/tapping) a row swaps the sticky
// image panel + its caption to that protocol. Row data lives in data-* attrs;
// the matching image is the [data-index] img in the stage. Progressive: with no
// JS the first image shows and every row still links to its protocol page.
export default class extends Controller {
  static targets = ["row", "img", "tag", "promise", "cta"]

  connect() {
    this.activate(0)
  }

  show(event) {
    const i = parseInt(event.currentTarget.dataset.index || "0", 10)
    this.activate(i)
  }

  activate(i) {
    this.rowTargets.forEach((r) => r.classList.toggle("is-active", parseInt(r.dataset.index, 10) === i))
    this.imgTargets.forEach((im) => im.classList.toggle("is-shown", parseInt(im.dataset.index, 10) === i))
    const row = this.rowTargets.find((r) => parseInt(r.dataset.index, 10) === i)
    if (!row) return
    if (this.hasTagTarget) this.tagTarget.textContent = row.dataset.tag || ""
    if (this.hasPromiseTarget) this.promiseTarget.textContent = row.dataset.promise || ""
    if (this.hasCtaTarget && row.dataset.href) this.ctaTarget.setAttribute("href", row.dataset.href)
  }
}

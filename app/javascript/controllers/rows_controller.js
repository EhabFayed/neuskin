import { Controller } from "@hotwired/stimulus"

// Repeating rows on an admin form (protocol timeline stages, FAQ):
// "Add" stamps the <template> with a fresh index, "Remove" flags a saved row
// for deletion (hidden _destroy) and hides it, or simply drops a new row.
// The server keeps rows in Order-field order and ignores removed/blank ones.
export default class extends Controller {
  static targets = ["list", "template", "row", "destroy", "number", "empty"]

  add() {
    const idx = String(Date.now())
    const n = this.liveRows().length + 1
    const html = this.templateTarget.innerHTML.replaceAll("__IDX__", idx).replaceAll("__N__", String(n))
    this.listTarget.insertAdjacentHTML("beforeend", html)
    const row = this.listTarget.lastElementChild
    row.dataset.fresh = "1"
    row.querySelector("input, textarea")?.focus()
    this.refresh()
  }

  remove(event) {
    const row = event.target.closest("[data-rows-target='row']")
    if (!row) return
    if (row.dataset.fresh) {
      row.remove()
    } else {
      row.querySelector("[data-rows-target='destroy']").value = "1"
      row.hidden = true
    }
    this.refresh()
  }

  liveRows() {
    return this.rowTargets.filter((r) => !r.hidden)
  }

  refresh() {
    const rows = this.liveRows()
    rows.forEach((r, i) => { const n = r.querySelector("[data-rows-target='number']"); if (n) n.textContent = String(i + 1) })
    if (this.hasEmptyTarget) this.emptyTarget.hidden = rows.length > 0
  }
}

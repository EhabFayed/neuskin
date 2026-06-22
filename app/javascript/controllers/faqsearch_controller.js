import { Controller } from "@hotwired/stimulus"

// FAQ search (§14): filters questions live across both languages using each
// item's data-search text. Hides groups with no visible items and shows a
// no-results message when nothing matches.
export default class extends Controller {
  static targets = ["query", "item", "group", "empty"]

  filter() {
    const q = this.queryTarget.value.trim().toLowerCase()
    let anyVisible = false

    this.itemTargets.forEach((item) => {
      const match = q === "" || item.dataset.search.includes(q)
      item.hidden = !match
      if (match) anyVisible = true
      if (!match) item.open = false
    })

    // Hide a group entirely when none of its items match.
    this.groupTargets.forEach((group) => {
      const hasVisible = group.querySelectorAll("[data-faqsearch-target='item']:not([hidden])").length > 0
      group.hidden = !hasVisible
    })

    this.emptyTarget.hidden = anyVisible
  }
}

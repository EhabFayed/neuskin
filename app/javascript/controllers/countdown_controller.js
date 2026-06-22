import { Controller } from "@hotwired/stimulus"

// Wedding-date countdown (§10). On date change, shows days remaining and the
// Bride's 180 window the date falls in. The number creates urgency — the brand
// stays quiet. Window copy is supplied via data-countdown-*-value (i18n).
export default class extends Controller {
  static targets = ["input", "output", "days", "message"]
  static values = {
    ample: String,   // > 180 days
    ideal: String,   // 90–180 days
    soon: String,    // < 90 days
    today: String,   // today / past
    daysLabel: String
  }

  change() {
    const value = this.inputTarget.value
    if (!value) {
      this.outputTarget.hidden = true
      return
    }

    // Parse as a local date (avoid TZ drift from new Date("YYYY-MM-DD")).
    const [y, m, d] = value.split("-").map(Number)
    const wedding = new Date(y, m - 1, d)
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const days = Math.round((wedding - today) / 86400000)

    let message
    if (days <= 0) message = this.todayValue
    else if (days > 180) message = this.ampleValue
    else if (days >= 90) message = this.idealValue
    else message = this.soonValue

    this.daysTarget.textContent =
      days <= 0 ? "—" : `${days} ${this.daysLabelValue}`
    this.messageTarget.textContent = message
    this.outputTarget.hidden = false
  }
}

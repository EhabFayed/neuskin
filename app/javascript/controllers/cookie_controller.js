import { Controller } from "@hotwired/stimulus"

// Cookie consent banner (§15). Shows once until the visitor chooses; the choice
// is remembered in localStorage. No tracking cookies are set here — this only
// records consent, so analytics can check it before loading later.
const KEY = "neuskin-cookie-consent"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    if (!localStorage.getItem(KEY)) {
      this.bannerTarget.hidden = false
    }
  }

  accept() {
    this.store("all")
  }

  decline() {
    this.store("essential")
  }

  store(choice) {
    try {
      localStorage.setItem(KEY, choice)
    } catch (e) {
      // localStorage unavailable (private mode) — just dismiss for this visit.
    }
    this.bannerTarget.hidden = true
  }
}

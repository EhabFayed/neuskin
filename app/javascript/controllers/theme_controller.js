import { Controller } from "@hotwired/stimulus"

// Manages the dark ↔ light theme toggle.
// Reads/writes localStorage("ns-theme") and sets data-theme="light" on <html>.
// A tiny inline script in the <head> applies the saved theme before CSS loads
// to prevent flash; this controller keeps the button state in sync.
export default class extends Controller {
  connect() {
    // Sync button aria-label to current state
    this._update()
  }

  toggle() {
    const html = document.documentElement
    const next = html.dataset.theme === "light" ? "dark" : "light"
    if (next === "light") {
      html.dataset.theme = "light"
      localStorage.setItem("ns-theme", "light")
    } else {
      delete html.dataset.theme
      localStorage.setItem("ns-theme", "dark")
    }
    this._update()
  }

  _update() {
    const isLight = document.documentElement.dataset.theme === "light"
    const label = isLight ? "Switch to dark mode" : "Switch to light mode"
    this.element.setAttribute("aria-label", label)
    this.element.setAttribute("title", label)
  }
}

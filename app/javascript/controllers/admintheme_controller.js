import { Controller } from "@hotwired/stimulus"

// NeuSkin Studio dark ↔ light toggle (audit item 17).
// Sets/removes data-admin-theme="light" on <html> and persists the choice in
// localStorage("ns-admin-theme"). Default (no attribute) is the dark palette.
// A tiny inline <script> in layouts/admin.html.erb <head> applies the saved
// value before CSS paints; this controller only flips it and keeps the
// button's label in sync (Turbo Drive swaps <body>, so connect() re-runs on
// every visit while the <html> attribute survives).
const KEY = "ns-admin-theme"

export default class extends Controller {
  connect() {
    this._sync()
  }

  toggle() {
    const html = document.documentElement
    const toLight = html.getAttribute("data-admin-theme") !== "light"
    if (toLight) {
      html.setAttribute("data-admin-theme", "light")
    } else {
      html.removeAttribute("data-admin-theme")
    }
    try {
      localStorage.setItem(KEY, toLight ? "light" : "dark")
    } catch (_e) {
      // private mode / storage blocked — the toggle still works for this page
    }
    this._sync()
  }

  _sync() {
    const isLight = document.documentElement.getAttribute("data-admin-theme") === "light"
    const label = isLight ? "Switch to dark mode" : "Switch to light mode"
    this.element.setAttribute("aria-label", label)
    this.element.setAttribute("title", label)
    this.element.setAttribute("aria-pressed", String(isLight))
  }
}

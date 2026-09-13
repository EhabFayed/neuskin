import { Controller } from "@hotwired/stimulus"

// Site navigation: burger toggle for the mobile panel, and tap-to-open
// submenus (Protocols / Treatments / Technologies) where hover doesn't exist.
// Desktop hover is pure CSS; this controller only adds the click/keyboard
// paths and closes everything on Escape, outside click, or a Turbo visit.
export default class extends Controller {
  static targets = ["panel", "burger", "item"]

  connect() {
    this.onKey = (e) => { if (e.key === "Escape") this.closeAll() }
    this.onDoc = (e) => { if (!this.element.contains(e.target)) this.closeSubs() }
    document.addEventListener("keydown", this.onKey)
    document.addEventListener("click", this.onDoc)
    document.addEventListener("turbo:before-visit", this.closeAll)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKey)
    document.removeEventListener("click", this.onDoc)
    document.removeEventListener("turbo:before-visit", this.closeAll)
    document.documentElement.classList.remove("nav-open")
  }

  toggle() {
    const open = !this.element.classList.contains("is-open")
    this.element.classList.toggle("is-open", open)
    document.documentElement.classList.toggle("nav-open", open)
    if (this.hasBurgerTarget) this.burgerTarget.setAttribute("aria-expanded", String(open))
    if (!open) this.closeSubs()
  }

  // Caret button next to a parent link: opens that submenu, closes siblings.
  toggleSub(event) {
    event.preventDefault()
    event.stopPropagation()
    const item = event.currentTarget.closest("[data-nav-target='item']")
    const open = !item.classList.contains("is-open")
    this.closeSubs()
    item.classList.toggle("is-open", open)
    event.currentTarget.setAttribute("aria-expanded", String(open))
  }

  closeSubs() {
    this.itemTargets.forEach((it) => {
      it.classList.remove("is-open")
      const btn = it.querySelector("[aria-expanded]")
      if (btn) btn.setAttribute("aria-expanded", "false")
    })
  }

  closeAll = () => {
    this.element.classList.remove("is-open")
    document.documentElement.classList.remove("nav-open")
    if (this.hasBurgerTarget) this.burgerTarget.setAttribute("aria-expanded", "false")
    this.closeSubs()
  }
}

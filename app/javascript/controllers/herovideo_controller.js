import { Controller } from "@hotwired/stimulus"

// Home hero film. The <video> ships with only a lightweight WebP poster; the
// clip itself is attached lazily, and only where it earns its bytes:
//   • phones / narrow viewports  → poster only (the 13 MB clip was the mobile LCP)
//   • reduced-motion / Save-Data → poster only
//   • otherwise                  → attach the 1280p clip once the page has loaded
export default class extends Controller {
  static values = { src: String }

  connect() {
    const video = this.element
    const narrow = window.matchMedia("(max-width: 880px)").matches
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    const saveData = navigator.connection && navigator.connection.saveData
    if (narrow || reduce || saveData || !this.srcValue) return

    video.addEventListener("playing", () => video.classList.add("is-playing"), { once: true })

    const attach = () => {
      if (video.querySelector("source")) return
      const source = document.createElement("source")
      source.src = this.srcValue
      source.type = "video/mp4"
      video.appendChild(source)
      video.load()
      const p = video.play()
      if (p && p.catch) p.catch(() => {})
    }
    if (document.readyState === "complete") setTimeout(attach, 150)
    else window.addEventListener("load", () => setTimeout(attach, 150), { once: true })
  }
}

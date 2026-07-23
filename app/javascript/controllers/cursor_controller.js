import { Controller } from "@hotwired/stimulus"

// Custom cursor: a cream dot rides the pointer exactly; a mauve ring trails
// it with damped easing (rAF loop) and swells over anything clickable.
// Mounted on <body>. Bails out on coarse pointers and under reduced motion,
// leaving the native cursor untouched; over form fields the pair fades out
// so the native I-beam comes back.
export default class extends Controller {
  connect() {
    const fine = window.matchMedia("(pointer: fine)").matches
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (!fine || reduce) return

    this.dot = document.createElement("div")
    this.dot.className = "ns-cursor-dot"
    this.ring = document.createElement("div")
    this.ring.className = "ns-cursor-ring"
    this.element.append(this.dot, this.ring)
    document.documentElement.classList.add("ns-cursor-on")

    this.x = this.rx = -100
    this.y = this.ry = -100
    this.seen = false

    this.onMove = (e) => {
      this.x = e.clientX
      this.y = e.clientY
      if (!this.seen) {
        // first sighting: park the ring on the pointer so it doesn't fly in
        this.seen = true
        this.rx = this.x
        this.ry = this.y
        this.dot.classList.add("is-shown")
        this.ring.classList.add("is-shown")
      }
      this.dot.style.transform = `translate(${this.x}px, ${this.y}px)`
      const t = e.target instanceof Element ? e.target : null
      const field = t?.closest("input, textarea, select")
      this.dot.classList.toggle("is-muted", !!field)
      this.ring.classList.toggle("is-muted", !!field)
      const hot = !field && t?.closest("a, button, [role='button'], summary, label, [data-cursor='hover']")
      this.ring.classList.toggle("is-hot", !!hot)
    }
    this.onDown = () => {
      this.dot.classList.add("is-down")
      this.ring.classList.add("is-down")
    }
    this.onUp = () => {
      this.dot.classList.remove("is-down")
      this.ring.classList.remove("is-down")
    }
    // pointer left the window entirely — hide until it returns
    this.onOut = (e) => {
      if (!e.relatedTarget) {
        this.dot.classList.remove("is-shown")
        this.ring.classList.remove("is-shown")
        this.seen = false
      }
    }

    window.addEventListener("pointermove", this.onMove, { passive: true })
    window.addEventListener("pointerdown", this.onDown, { passive: true })
    window.addEventListener("pointerup", this.onUp, { passive: true })
    document.addEventListener("pointerout", this.onOut)

    const trail = () => {
      this.rx += (this.x - this.rx) * 0.16
      this.ry += (this.y - this.ry) * 0.16
      this.ring.style.transform = `translate(${this.rx}px, ${this.ry}px)`
      this.raf = requestAnimationFrame(trail)
    }
    this.raf = requestAnimationFrame(trail)
  }

  disconnect() {
    if (!this.dot) return
    cancelAnimationFrame(this.raf)
    window.removeEventListener("pointermove", this.onMove)
    window.removeEventListener("pointerdown", this.onDown)
    window.removeEventListener("pointerup", this.onUp)
    document.removeEventListener("pointerout", this.onOut)
    document.documentElement.classList.remove("ns-cursor-on")
    this.dot.remove()
    this.ring.remove()
    this.dot = this.ring = null
  }
}

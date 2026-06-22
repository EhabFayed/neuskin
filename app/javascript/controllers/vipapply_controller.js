import { Controller } from "@hotwired/stimulus"

// Private Care application (§09): composes a private WhatsApp message from the
// application fields and points the submit link at it. No DB — discretion by
// design. The PRIVATE codeword stays in the message so the lead is routed to
// the VIP track. Falls back to a plain wa.me link if JS is off (set in the view).
export default class extends Controller {
  static targets = ["name", "contact", "referral", "note", "submit"]

  compose(event) {
    const base = this.submitTarget.getAttribute("href")
    // Keep the existing wa.me/<number>?text= base, replace the text payload.
    const url = new URL(base)
    const lines = [
      "PRIVATE — Application for Private Care.",
      this.nameTarget.value && `Name: ${this.nameTarget.value}`,
      this.contactTarget.value && `Contact: ${this.contactTarget.value}`,
      this.referralTarget.value && `Referred by: ${this.referralTarget.value}`,
      this.noteTarget.value && `Note: ${this.noteTarget.value}`
    ].filter(Boolean)
    url.searchParams.set("text", lines.join("\n"))
    this.submitTarget.setAttribute("href", url.toString())
    // Let the click proceed to WhatsApp with the freshly composed message.
  }
}

import { Controller } from "@hotwired/stimulus"

// KSA mobile field: strips non-digits, drops a leading 0 or 966 country code,
// and caps at 9 digits (5XXXXXXXX). The +966 prefix is shown in the UI; the
// model normalizes again server-side, so this is convenience, not the source
// of truth.
export default class extends Controller {
  static targets = ["input"]

  format() {
    let v = this.inputTarget.value.replace(/\D/g, "")
    v = v.replace(/^966/, "").replace(/^0/, "")
    this.inputTarget.value = v.slice(0, 9)
  }
}

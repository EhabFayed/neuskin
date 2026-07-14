# Single source of truth for clinic contact constants.
# WhatsApp number: placeholder for now — swap by setting ENV["WHATSAPP_NUMBER"]
# (digits only, international format, no "+"). See docs/DESIGN-AND-TECH-DIRECTION.md.
module Clinic
  WHATSAPP_NUMBER = ENV.fetch("WHATSAPP_NUMBER", "966500000000").freeze

  # Where lead notifications land. Override in production via ENV.
  INFO_EMAIL = ENV.fetch("CLINIC_INFO_EMAIL", "hello@neuskin.sa").freeze
  MAIL_FROM  = ENV.fetch("MAIL_FROM", "NeuSkin Clinic <hello@neuskin.sa>").freeze

  # Builds a tracked wa.me deep link. `text` is the prefilled message; an
  # optional codeword is prepended so the patient-relations lead sees which
  # protocol/channel the inquiry came from (architecture §08).
  def self.whatsapp_url(text:, codeword: nil)
    message = codeword.present? ? "#{codeword} — #{text}" : text
    "https://wa.me/#{WHATSAPP_NUMBER}?text=#{ERB::Util.url_encode(message)}"
  end
end

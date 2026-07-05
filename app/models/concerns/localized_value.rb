module LocalizedValue
  extend ActiveSupport::Concern

  # Returns the Arabic value when the active locale is Arabic, else English.
  # Blank strings are treated as nil so callers can chain `|| fallback`.
  def localized(ar, en)
    value = I18n.locale == :ar ? ar : en
    value.presence
  end
end

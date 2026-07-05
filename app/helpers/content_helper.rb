module ContentHelper
  # Memoized per request. Never nil (Section.for returns a blank when missing).
  def sec(page, kind)
    @__sections ||= {}
    @__sections[[page.to_s, kind.to_s]] ||= Section.for(page, kind)
  end

  # Locale-aware text for a Content key. Safe empty string when absent.
  def sec_text(page, kind, key)
    sec(page, kind).text(key)
  end

  # JSONB items array for a repeating-group section. Safe [] when absent.
  def sec_items(page, kind)
    sec(page, kind).items || []
  end

  # ActiveStorage image URL when attached, else the static asset fallback.
  def sec_image(page, kind, fallback_key)
    section = sec(page, kind)
    if section.persisted? && section.image.attached?
      url_for(section.image)
    else
      ns_image(fallback_key)
    end
  end
end

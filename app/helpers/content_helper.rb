module ContentHelper
  # Memoized per request. Never nil (Section.for returns a blank when missing).
  #
  # In the admin section preview (Admin::SectionsController#preview), the
  # controller sets @__preview_section to an UNSAVED Section carrying the
  # editor's in-progress values. When the page renders the block being edited,
  # we return that instead of the DB record — so the iframe shows unsaved edits.
  def sec(page, kind)
    if @__preview_section &&
       @__preview_section.page == page.to_s &&
       @__preview_section.kind == kind.to_s
      return @__preview_section
    end

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

  # <img> tag sourced from the section's attached image, falling back to the
  # static NS_IMAGES asset. Drop-in replacement for ns_image_tag so views can
  # become image-editable without changing their markup. Extra opts (alt,
  # class, …) pass straight through, exactly like ns_image_tag.
  def sec_image_tag(page, kind, fallback_key, alt: "", **opts)
    section = sec(page, kind)
    if section.persisted? && section.image.attached?
      image_tag(section.image, alt: alt, **opts)
    else
      ns_image_tag(fallback_key, alt: alt, **opts)
    end
  end

  # Ordered list of gallery image URLs for a section (has_many_attached
  # :gallery). Falls back to the given static keys (array) when nothing is
  # attached, so galleries render unchanged before migration.
  def sec_gallery_urls(page, kind, fallback_keys = [])
    section = sec(page, kind)
    if section.persisted? && section.gallery.attached?
      section.gallery.map { |img| url_for(img) }
    else
      Array(fallback_keys).map { |k| ns_image(k) }
    end
  end
end

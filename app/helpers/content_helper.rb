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
    # Tag the img so the editor's live preview can swap in a just-picked
    # (not-yet-uploaded) image before saving. Harmless on the public site.
    opts = opts.merge(data: (opts[:data] || {}).merge("sec-image": "#{page}/#{kind}"))
    if section.persisted? && section.image.attached?
      image_tag(section.image, alt: alt, **opts)
    else
      ns_image_tag(fallback_key, alt: alt, **opts)
    end
  end

  # Flip-card sections and their per-card image slots: count of cards and the
  # content key that names each card (used as the slot label in the editor).
  SECTION_CARD_SLOTS = {
    "home/home_principles"        => { count: 3, label_key: "p%d_title" },
    "the_clinic/clinic_journey"   => { count: 4, label_key: "step_%d_title" },
    "dr_maysa/drmaysa_method"     => { count: 3, label_key: "step_%d_title" },
    "maysa_method/method_pillars" => { count: 4, label_key: "pillar_%d_title" },
    "maysa_method/method_timeline" => { count: 4, label_key: "panel_%d_title" },
    "bridal/bridal_timeline"      => { count: 3, label_key: "stage_%d_title" },
    "bridal/bridal_pillars"       => { count: 3, label_key: "pillar_%d_title" },
    "private_care/private_tiers"  => { count: 3, label_key: "tier_%d_name" }
  }.freeze

  # URL for card slot `index` (1-based) of a section: the dashboard slot image
  # when attached, else the legacy gallery image at that position, else the
  # given static asset fallback.
  def sec_card_image(page, kind, index, fallback_path)
    section = sec(page, kind)
    if section.persisted?
      slot = section.public_send("card_image_#{index}")
      return url_for(slot) if slot.attached?

      legacy = section.gallery
      return url_for(legacy[index - 1]) if legacy.attached? && legacy[index - 1]
    end
    image_path(fallback_path)
  end

  # Card / hero image URL for a Treatment: the dashboard-attached image when
  # present, else the launch static asset for the original five slugs, else
  # the treatment-room photo for newly created outcomes.
  TREATMENT_FALLBACK_IMAGES = {
    "skin"        => :outcome_skin,
    "hair"        => :outcome_hair,
    "body"        => :outcome_body,
    "injectables" => :outcome_injectables,
    "devices"     => :outcome_devices
  }.freeze

  def treatment_image_url(treatment)
    return url_for(treatment.image) if treatment.image.attached?

    ns_image(TREATMENT_FALLBACK_IMAGES.fetch(treatment.slug, :treatment_room))
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

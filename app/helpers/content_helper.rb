module ContentHelper
  # ---- Image delivery (client audit, Sept 2026: "convert to WebP, shrink") ----
  # Every dashboard-uploaded image is served as an Active Storage VARIANT:
  # resized to the width its slot actually needs and re-encoded as WebP. The
  # variant is generated once (libvips), stored next to the original, and the
  # proxy URL is long-cached. Originals stay untouched so editors can keep
  # uploading full-size JPG/PNG.
  VARIANT_QUALITY = 78

  # Accepts an Attached::One (has_one_attached), a single Attachment out of a
  # has_many_attached gallery, or a Blob. Anything non-variable (SVG, missing
  # file, unknown type) comes back untouched and is served as before.
  def optimized(attachment, width: 1200)
    return attachment if attachment.respond_to?(:attached?) && !attachment.attached?
    return attachment unless attachment.respond_to?(:variable?) && attachment.variable?

    attachment.variant(resize_to_limit: [ width, nil ], format: :webp,
                       saver: { quality: VARIANT_QUALITY, strip: true })
  rescue StandardError
    attachment
  end

  # Relative proxy path for the optimized image (variants are otherwise
  # url_for'd with the request host, which is noise in the HTML).
  def opt_url(attachment, width: 1200)
    img = optimized(attachment, width: width)
    img.is_a?(ActiveStorage::VariantWithRecord) || img.is_a?(ActiveStorage::Variant) ? rails_storage_proxy_path(img) : url_for(img)
  end

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
    @__sections[[ page.to_s, kind.to_s ]] ||= Section.for(page, kind)
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
  def sec_image(page, kind, fallback_key, width: 1800)
    section = sec(page, kind)
    if section.persisted? && section.image.attached?
      opt_url(section.image, width: width)
    else
      ns_image(fallback_key)
    end
  end

  # <img> tag sourced from the section's attached image, falling back to the
  # static NS_IMAGES asset. Drop-in replacement for ns_image_tag so views can
  # become image-editable without changing their markup. Extra opts (alt,
  # class, …) pass straight through, exactly like ns_image_tag.
  def sec_image_tag(page, kind, fallback_key, alt: "", width: 1600, **opts)
    section = sec(page, kind)
    # Tag the img so the editor's live preview can swap in a just-picked
    # (not-yet-uploaded) image before saving. Harmless on the public site.
    opts = opts.merge(data: (opts[:data] || {}).merge("sec-image": "#{page}/#{kind}"))
    opts[:decoding] ||= "async"
    if section.persisted? && section.image.attached?
      image_tag(opt_url(section.image, width: width), alt: alt, **opts)
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
  def sec_card_image(page, kind, index, fallback_path, width: 1000)
    section = sec(page, kind)
    if section.persisted?
      slot = section.public_send("card_image_#{index}")
      return opt_url(slot, width: width) if slot.attached?

      legacy = section.gallery
      return opt_url(legacy[index - 1], width: width) if legacy.attached? && legacy[index - 1]
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

  def treatment_image_url(treatment, width: 1200)
    return opt_url(treatment.image, width: width) if treatment.image.attached?

    ns_image(TREATMENT_FALLBACK_IMAGES.fetch(treatment.slug, :treatment_room))
  end

  # Stage / card / hero image URL for a Protocol: the dashboard-attached image
  # (Admin → Protocols) when present, else the launch static asset for the
  # original six slugs, else a generic clinic shot for new protocols.
  PROTOCOL_FALLBACK_IMAGES = {
    "neuskin-method"    => "site/protocols/neuskin-method.webp",
    "90-day-glow-reset" => "site/protocols/glow-reset.webp",
    "brides-180"        => "site/protocols/bridal.webp",
    "reset-crown"       => "site/protocols/hair.webp",
    "8-week-sculpt"     => "site/protocols/sculpt.webp",
    "skin-insider"      => "site/protocols/insider.webp"
  }.freeze

  def protocol_image_url(protocol, width: 1200)
    return opt_url(protocol.image, width: width) if protocol.image.attached?

    image_path(PROTOCOL_FALLBACK_IMAGES.fetch(protocol.slug, "site/protocols/skin.webp"))
  end

  # Ordered list of gallery image URLs for a section (has_many_attached
  # :gallery). Falls back to the given static keys (array) when nothing is
  # attached, so galleries render unchanged before migration.
  def sec_gallery_urls(page, kind, fallback_keys = [], width: 1200)
    section = sec(page, kind)
    if section.persisted? && section.gallery.attached?
      section.gallery.map { |img| opt_url(img, width: width) }
    else
      Array(fallback_keys).map { |k| ns_image(k) }
    end
  end
end

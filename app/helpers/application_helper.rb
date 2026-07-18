module ApplicationHelper
  # View-side wrapper around Clinic.whatsapp_url. Pulls the prefill text from
  # the current locale.
  def whatsapp_url(codeword: nil)
    Clinic.whatsapp_url(text: t("whatsapp.prefill"), codeword: codeword)
  end

  # Design image keys → real asset paths. The "NeuSkin Clinic (standalone)"
  # design references images by semantic key (img.portraitNatural, img.lounge…);
  # this maps each to an asset on disk so every page references the same files.
  NS_IMAGES = {
    # Real clinic photography (content team batch, July 2026) — WebP.
    portrait_natural: "site/people/maysa.webp",
    doctor_coat:      "site/people/maysa.webp",
    maysa_hero:       "site/people/maysa-hero.webp",
    founder_portrait: "site/people/maysa-founder.webp",
    hero_clinic:      "site/hero-clinic.webp",
    clinic_hero:      "site/space/clinic-hero.webp",
    treatment_room:   "site/space/treatment.webp",
    lounge:           "site/space/waiting-lounge.webp",
    device_table:     "site/space/device-room.webp",
    diptyque:         "site/space/private-suite.webp",
    interior_ext:     "site/space/entrance.webp",
    clinic_shot_1:    "site/space/clinic-1.webp",
    clinic_shot_2:    "site/space/clinic-2.webp",
    clinic_shot_3:    "site/space/clinic-3.webp",
    clinic_shot_4:    "site/space/clinic-4.webp",
    clinic_shot_5:    "site/space/clinic-5.webp",
    consult:          "site/space/consultation.jpg",
    beauty_eyes:      "site/protocols/skin.jpg",
    protocols_hero:   "site/protocols-hero.jpg",
    bride_bouquet:    "site/bridal-mood.jpg",
    resort:           "site/desert-atmosphere.jpg",
    # Treatment outcome heroes (design keys facialBrush/salon/fitness1/
    # injectable/devices2), mapped to the closest assets on disk.
    outcome_skin:        "site/protocols/skin.jpg",
    outcome_hair:        "site/protocols/hair.jpg",
    outcome_body:        "site/protocols/sculpt.jpg",
    outcome_injectables: "site/space/treatment.webp",
    outcome_devices:     "site/space/device-room.webp"
  }.freeze

  # Asset path for a design image key (symbol). Falls back to the brand mark.
  def ns_image(key)
    asset_path(NS_IMAGES.fetch(key.to_sym, "site/logo-ns.png"))
  end

  # <img> tag for a design image key, with object-fit handled by the CSS class.
  def ns_image_tag(key, alt: "", **opts)
    image_tag(NS_IMAGES.fetch(key.to_sym, "site/logo-ns.png"), alt: alt, **opts)
  end

  # Returns the string for the active locale. The whole site renders one
  # language at a time (Arabic when locale == :ar, English otherwise).
  def loc(ar:, en:)
    I18n.locale == :ar ? ar : en
  end

  # True when the active locale is Arabic (RTL).
  def ar?
    I18n.locale == :ar
  end

  # Wraps text in a <span> carrying the correct dir for the active locale —
  # used inside mixed runs. Returns an html_safe span.
  def loc_dir
    ar? ? "rtl" : "ltr"
  end

  # URL for the CURRENT page in the other locale — so the language toggle stays
  # on the same page (and keeps query params like ?persona=) instead of jumping
  # home. Arabic is the default, so it carries no /ar prefix.
  def switch_locale_url
    other = ar? ? :en : :ar
    # Merge the resolved route params (controller/action/:id/:slug) + the query
    # string, then override locale. Rebuilds the exact current page in the other
    # locale. Arabic is default, so it carries no /ar prefix.
    params = request.path_parameters.merge(request.query_parameters).symbolize_keys
    params[:locale] = (other == I18n.default_locale ? nil : other)
    url_for(params.merge(only_path: true))
  rescue ActionController::UrlGenerationError
    root_path(locale: (other == I18n.default_locale ? nil : other))
  end
end

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
    portrait_natural: "site/people/maysa.jpg",
    doctor_coat:      "site/people/maysa.jpg",
    treatment_room:   "site/space/treatment.jpg",
    lounge:           "site/space/waiting-lounge.jpg",
    device_table:     "site/space/device-room.jpg",
    diptyque:         "site/space/private-suite.jpg",
    interior_ext:     "site/space/entrance.jpg",
    consult:          "site/space/consultation.jpg",
    beauty_eyes:      "site/protocols/skin.jpg",
    bride_bouquet:    "site/bridal-mood.jpg",
    resort:           "site/desert-atmosphere.jpg",
    # Treatment outcome heroes (design keys facialBrush/salon/fitness1/
    # injectable/devices2), mapped to the closest assets on disk.
    outcome_skin:        "site/protocols/skin.jpg",
    outcome_hair:        "site/protocols/hair.jpg",
    outcome_body:        "site/protocols/sculpt.jpg",
    outcome_injectables: "site/space/treatment.jpg",
    outcome_devices:     "site/space/device-room.jpg"
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

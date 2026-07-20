# Friendly names for each editable page. Drives the admin Pages index so a
# non-technical editor sees "The Clinic", not "the_clinic". Order = nav order.
module SitePages
  LIST = [
    { slug: "home",           name: "Home" },
    # Dr. Maysa page hidden (July 2026 content deck) — entry removed so the
    # dashboard doesn't offer it. Restore alongside the route in routes.rb.
    { slug: "the_clinic",     name: "The Clinic" },
    { slug: "maysa_method",   name: "The Maysa Method" },
    { slug: "the_team",       name: "The Medical Team" },
    { slug: "treatments",     name: "Treatments" },
    { slug: "technologies",   name: "Our Technologies" },
    { slug: "private_care",   name: "Private Care" },
    { slug: "journal",        name: "Journal" },
    { slug: "stories",        name: "Patient Stories" },
    { slug: "faq",            name: "FAQ" },
    { slug: "legal",          name: "Legal" },
    { slug: "protocols_index", name: "Protocols (hub)" },
    { slug: "bridal",         name: "Bridal Concierge" },
    { slug: "global",         name: "Site-wide" }
  ].freeze

  def self.name_for(slug)
    LIST.find { |p| p[:slug] == slug.to_s }&.fetch(:name) || slug.to_s.titleize
  end
end

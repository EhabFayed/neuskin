module PagesHelper
  # Placeholder protocol data for the homepage grid. Replaced by the Protocol
  # model in a later step (see docs/DESIGN-AND-TECH-DIRECTION.md §2.6).
  def protocols
    [
      { name_ar: "منهج ميساء", name_en: "The Maysa Method", tm: true,
        promise: "The diagnostic foundation. Where every plan begins.", meta: "1 session · First-time patients" },
      { name_ar: "توهّج التسعين يومًا", name_en: "90-Day Glow Reset",
        promise: "Skin restoration for dullness, texture and mild pigmentation.", meta: "12 weeks · Skin reset" },
      { name_ar: "عروس ١٨٠", name_en: "Bride's 180",
        promise: "Your skin in six months — planned, in order, by a doctor.", meta: "180 days · Pre-wedding" },
      { name_ar: "تاج التجدّد", name_en: "Reset Crown",
        promise: "Hair and scalp, for postpartum and stress shedding.", meta: "12–16 weeks · Hair" },
      { name_ar: "نحت الثمانية أسابيع", name_en: "8-Week Sculpt",
        promise: "Body contour, for tone, strength and posture.", meta: "8 weeks · Body" },
      { name_ar: "عضوية المطّلعات", name_en: "Skin Insider Membership",
        promise: "Quiet maintenance, for long-term patients.", meta: "Annual · Maintenance" }
    ]
  end
end

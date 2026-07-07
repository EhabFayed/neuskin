# Treatment outcome pages content seed (design §08 "Outcome" screen —
# /treatments/skin·hair·body·injectables·devices).
#
# EN values are copied verbatim from the design's OUT data, which are also the
# hardcoded fallbacks in app/views/pages/treatment_outcome.html.erb — so
# seeding this data does not change the rendered pages. AR values are
# intentionally left blank; editors will add Arabic copy later via the CMS.
#
# The owning protocol per outcome is routing data, not display copy, so it
# stays in PagesController::TREATMENT_OUTCOME_OWNERS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

OUTCOME_SEED = [
  { slug: "skin", label: "Skin — tired, dull skin",
    title: "Tired, dull skin", headline: "What we do for tired skin",
    look: "Skin that has gone flat — dull where it used to catch the light, uneven in tone, slow to recover after a late week. Not damaged. Just tired.",
    how:  "We start by reading why, not reaching for a device. Most dullness is a barrier, hydration and turnover story before it is anything else. From there, a sequenced plan rebuilds clarity over weeks, measured against where your skin began.",
    view: "Tired skin is rarely one problem; it’s usually three small ones compounding. Treat the cause in order and the glow returns on its own — chasing it with a single facial almost never holds." },
  { slug: "hair", label: "Hair — thinning & shedding",
    title: "Thinning & shedding", headline: "What we do for hair that’s shedding",
    look: "A part that widens. A ponytail that feels thinner in the hand. More strands than you remember on the pillow — often after a baby or a stretch of stress.",
    how:  "We assess the scalp clinically, look for treatable causes, and build a regenerative protocol to slow shedding and support density — reviewed against a baseline so progress is real, not hopeful.",
    view: "The earlier we see shedding, the more we can do. The follicle is patient, but it isn’t infinitely so — measured intervention beats another year of waiting for a shampoo to work." },
  { slug: "body", label: "Body — tone & contour",
    title: "Tone & contour", headline: "What we do for tone and contour",
    look: "You train, you eat well — and still there’s a gap between the effort and the outline. Softness where you’d like definition; posture that’s slipped.",
    how:  "A device-led, eight-week protocol supports muscle tone, contour and posture, with standardised measurements at the start and finish so the change is documented, not assumed.",
    view: "Body work should support your effort, never replace it. We measure posture and definition — not the scale — because that’s what actually changes how clothes sit and how you stand." },
  { slug: "injectables", label: "Injectables — lines & volume",
    title: "Lines & volume", headline: "What we do before we reach for a needle",
    look: "Early lines, a little lost volume, a face that reads tired before you feel it. The instinct is to ask for a syringe — ours is to ask why first.",
    how:  "Every injectable decision at NeuSkin follows a diagnosis, not a request. When it’s right, it’s precise and conservative. When it isn’t, we say so — and treat the cause instead.",
    view: "The best injectable result is the one nobody can name. Restraint is a clinical skill; the goal is you, rested — never you, edited." },
  { slug: "devices", label: "Advanced devices",
    title: "Advanced devices", headline: "What our devices are actually for",
    look: "EmFace, EmSculpt Neo, lasers, exosomes, polynucleotides — a vocabulary the industry loves and patients rarely need explained by name.",
    how:  "We choose the device to fit the outcome, never the other way around. Each is one tool inside a doctor-written plan — sequenced, measured, and only used when it earns its place.",
    view: "A device is a means, not a headline. If a clinic is selling you the machine before the diagnosis, you’re being sold to — not treated." }
].freeze

SeedContent.register("treatment_outcomes", OUTCOME_SEED.each_with_index.map do |o, i|
  {
    kind: "outcome_#{o[:slug]}", label: o[:label], position: i,
    contents: [
      { key: "title",    label: "Hero tag", en: o[:title], ar: "" },
      { key: "headline", label: "Hero headline", en: o[:headline], ar: "" },
      { key: "look",     label: "What it looks like", content_type: "richtext", en: o[:look], ar: "" },
      { key: "how",      label: "How NeuSkin treats it", content_type: "richtext", en: o[:how], ar: "" },
      { key: "view",     label: "Dr. Maysa's view (quote)", content_type: "richtext", en: o[:view], ar: "" }
    ]
  }
end)

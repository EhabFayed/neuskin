# The Medical Team page content seed.
#
# EN values are copied verbatim from the hardcoded literals in
# app/views/pages/the_team.html.erb (sec_text(...).presence || "<literal>"
# fallbacks), so seeding this data does not change the rendered page.
# AR values are intentionally left blank; the site currently renders English
# only, and editors will add Arabic copy later via the CMS.
#
# Idempotent: upserts by (page, kind) and (section, key).
require_relative "_registry"

SeedContent.register("the_team", [
  {
    kind: "team_hero", label: "Hero", position: 0,
    contents: [
      { key: "eyebrow",  label: "Eyebrow",
        en: "The Medical Team", ar: "" },
      { key: "title_1",  label: "Title part 1 (before emphasis)",
        en: "The people behind", ar: "" },
      { key: "title_em", label: "Title emphasis span",
        en: "the plan.", ar: "" },
      { key: "lead",     label: "Lead paragraph", content_type: "richtext",
        en: "A small, credentialed team — led by our medical director, organised by seniority, and chosen for restraint as much as skill.",
        ar: "" }
    ]
  },
  {
    kind: "team_members", label: "Team grid", position: 1,
    contents: [
      { key: "member_1_name",  label: "Member 1 name",
        en: "Medical Director", ar: "" },
      { key: "member_1_role",  label: "Member 1 role",
        en: "Medical Director", ar: "" },
      { key: "member_1_cred",  label: "Member 1 credentials",
        en: "MBBS · Dermatology · Aesthetic Medicine Fellowship", ar: "" },
      { key: "member_1_focus", label: "Member 1 focus",
        en: "Diagnosis & the 12-month plan", ar: "" },
      { key: "member_1_bio",   label: "Member 1 bio", content_type: "richtext",
        en: "Every patient begins and ends with the medical director, who reads the baseline, writes the plan, and signs off each quarterly review — the one constant across the whole journey.",
        ar: "" },

      { key: "member_2_name",  label: "Member 2 name",
        en: "Dr. Lina Haddad", ar: "" },
      { key: "member_2_role",  label: "Member 2 role",
        en: "Senior Aesthetic Physician", ar: "" },
      { key: "member_2_cred",  label: "Member 2 credentials",
        en: "MBBS · Diploma in Aesthetic Medicine", ar: "" },
      { key: "member_2_focus", label: "Member 2 focus",
        en: "Injectables & restraint", ar: "" },
      { key: "member_2_bio",   label: "Member 2 bio", content_type: "richtext",
        en: "Lina executes the plan with a light hand. Her reputation is built less on what she does than on what she declines to do — and patients trust her for exactly that.",
        ar: "" },

      { key: "member_3_name",  label: "Member 3 name",
        en: "Dr. Sara Othman", ar: "" },
      { key: "member_3_role",  label: "Member 3 role",
        en: "Dermatology Associate", ar: "" },
      { key: "member_3_cred",  label: "Member 3 credentials",
        en: "MBBS · Clinical Dermatology", ar: "" },
      { key: "member_3_focus", label: "Member 3 focus",
        en: "Skin barrier & pigment", ar: "" },
      { key: "member_3_bio",   label: "Member 3 bio", content_type: "richtext",
        en: "Sara handles the slow, unglamorous work that good skin actually depends on — barrier repair, pigment correction, and the careful sequencing that holds results over months.",
        ar: "" },

      { key: "member_4_name",  label: "Member 4 name",
        en: "Noor Al-Fahad", ar: "" },
      { key: "member_4_role",  label: "Member 4 role",
        en: "Patient Relations Lead", ar: "" },
      { key: "member_4_cred",  label: "Member 4 credentials",
        en: "First point of contact · privacy-trained", ar: "" },
      { key: "member_4_focus", label: "Member 4 focus",
        en: "Discretion & continuity", ar: "" },
      { key: "member_4_bio",   label: "Member 4 bio", content_type: "richtext",
        en: "Noor reads every inquiry personally and protects each patient's privacy from the first message to the last review. Nothing reaches the clinic floor that she has not handled with care.",
        ar: "" }
    ]
  }
])

# Our Technologies page + July content deck follow-ups — design

Source: "NeuSkin Website.pdf" (content team, July 19, 2026) compared against the
live site. Most of the deck's copy was already applied by the July 12 CMS seed.
This spec covers only what is still missing. Explicitly out of scope, per the
content team's notes: the home testimonials (`home_quotes`) and clinic
credentials (`clinic_credentials`) sections stay hidden.

## 1. New page: Our Technologies (`/technologies`)

The only entirely missing piece. A device-portfolio page presenting seven
FDA-cleared machines as flip cards (front: what it does for the patient;
back: technical specs), per the deck's Pinterest reference.

### Route / chrome
- `get "technologies", to: "pages#technologies", as: :technologies` inside the
  locale scope, after `treatments`.
- Empty `PagesController#technologies` action (CMS-driven page, like `the_clinic`).
- Header nav link after Treatments: `t("layout.nav.technologies")` —
  EN "Technologies", AR "التقنيات".
- Footer link in the Protocols column after Treatments:
  `t("layout.footer.technologies")` — EN "Our Technologies", AR "تقنياتنا".
- `SitePages::LIST` entry `{ slug: "technologies", name: "Our Technologies" }`
  after `treatments`, so the page is editable in the admin dashboard.

### Sections (page slug `technologies`, all admin-editable)
1. **`tech_hero`** — vertically split composite hero: 4 gallery images side by
   side (`tech page.jpg`, `tech page 2/3/4.jpg`), the last slice wider per the
   deck note ("bigger so the NeuSkin name shows"). Copy keys: `eyebrow`
   ("Our Technologies"), `title` ("Where Clinical Excellence" /
   "حيث يلتقي التميز الطبي"), `title_em` ("Meets Human Grace." /
   "برقيّ اللمسة الإنسانية."), `sub` (deck sub-headline EN/AR), `cta`
   ("Explore Our Treatments" / "اكتشفي خدماتنا") → `treatments_path`.
2. **`tech_intro`** — `title` "The Science of You" / "العلم خلف الجمال",
   `body` (deck EN/AR).
3. **`tech_device_1` … `tech_device_7`** — one section per device, in deck
   order: EMTONE (Harmonious Rejuvenation), EMFACE (Needle-Free Lift),
   EMSCULPT (Sculpted Strength), POTENZA (Advanced Skin Vitality),
   ELITE IQ (Precision Care), REVLITE (Luminous Renewal),
   EMERALD (Natural Fat Loss). Device names stay untranslated (same rule as
   protocol names). Keys: `name`, `tagline` (EN/AR), `body` (patient-facing,
   EN/AR), `specs` (EN/AR). Images: `image` = product shot (card front),
   `card_image_1` = in-clinic photo (card back) — registered in
   `ContentHelper::SECTION_CARD_SLOTS` with `label_key: "name"`.
4. **`tech_cta`** — `body` ("Ready to experience the NeuSkin difference? Your
   transformation begins here." EN/AR), `button` ("Book Your Consultation" /
   "احجزي استشارتك") → `inquire_path`.

### View & interaction
- `app/views/pages/technologies.html.erb`, following the existing page idiom
  (`page-hero`, `section-inner`, `eyebrow`, `reveal` targets, `cta-center`).
- Flip cards: `.flipcard` with CSS 3D transform; a tiny Stimulus
  `flip_controller.js` (registered in `controllers/index.js`) toggles
  `.is-flipped` on click/Enter so it works on touch; hover flips on pointer
  devices via CSS. Grid: responsive `.tech-grid` (3 / 2 / 1 columns).
- Styles appended to `application.css` in a commented `Technologies` block,
  using existing tokens. RTL-safe (logical properties / existing RTL rules).

### Seed
- `db/seed_content/technologies.rb` registered via `SeedContent.register`,
  full EN/AR copy from the deck. Applied to the dev DB.

## 2. Home "About NeuSkin" rewrite (`home_founder` section)

Deck replaces the first-person founder copy with third-person "About NeuSkin"
copy and finally supplies its Arabic (currently empty → AR visitors see
English). Update seed + DB:
- `eyebrow`: EN "About NeuSkin", AR "عن نيوسكن".
- `body_1` / `body_2`: deck third-person copy EN + AR.
- Portrait, signature "— Maysa", and the philosophy link stay.

## 3. Photo placement (files in `~/Downloads/neuphotos`, named by position)

| File | Destination |
|---|---|
| `doctor led.JPG`, `Discreet.jpg`, `Measured.jpg` | `home_principles` card slots 1–3 (view already supports `sec_card_image`) |
| `tech page.jpg`, `tech page 2/3/4.jpg` | `tech_hero` gallery (branded shot last, wider) |
| `<Tagline>.jpg/.jpeg/.png/.webp` (small) | matching `tech_device_N.image` (card front) |
| `<Tagline> image.JPG` / `Needle-Free Lift 2nd image .JPG` / `tech page after harmonious.JPG` | matching `tech_device_N.card_image_1` (card back; the "after harmonious" file is EMTONE's) |

Large camera JPEGs (6000×4000, 5–12 MB) are auto-oriented and downscaled to
web size before attaching. Attachment runs via `rails runner` inside the app
container (photos staged under the bind-mounted repo `tmp/`).

## 4. Small gaps carried, not invented

- Treatment category chip `title_ar` stays empty (deck provides no AR for the
  chips; AR pages fall back to EN chips) — flagged to the content team.
- Credentials license number remains the deck's placeholder; section stays
  hidden until a real SFDA/MOH number exists.

## Testing

- Request specs: `/technologies` (and `/ar` variant) render 200 with device
  names present; nav contains the new link. Existing suite must stay green.
- Manual: EN/AR render check via curl; confirm hidden sections still absent
  from home/clinic HTML.

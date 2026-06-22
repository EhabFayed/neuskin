# NeuSkin · Riyadh — Design & Tech Direction

*neuskin.me · Arabic-first, doctor-led, consultation-led · v1 · 2026-06-22*

This is the single brief that governs how the site looks and how it is built. It sits
between the **Website Architecture** document (what pages exist, section by section) and
the actual implementation. The architecture says *what*; this says *how it looks* and
*how it's built*.

The five brand rules from the architecture override everything here when they conflict:
Arabic-first, doctor-led, protocols-never-prices, WhatsApp-only CTA, quiet luxury.

A live homepage mockup applying this direction:
https://claude.ai/code/artifact/a129ce55-4a59-41fd-8cc3-2df5a72da733

---

## Part 1 · Design Direction

### 1.1 Mood

**Warm editorial, Riyadh-rooted.** Not the cool Swiss-clinic look (Clinique La Prairie),
not the dark members'-club look. The page should feel like a doctor's considered letter,
not a beauty ad: bone-and-parchment ground, warm ink, a single clay-rose accent, generous
negative space, and slow motion. The absence of marketing pressure is the marketing.

The deliberate move that keeps this from reading as a generic "cream + serif" template:
**Arabic typography is the hero, not Latin.** Arabic headlines lead and are set large;
English sits underneath as the secondary line. This is the architecture's "the Arabic
version is the original, not a translation" rule made visible in the type itself.

### 1.2 Color tokens

Committed palette. These become CSS custom properties verbatim — every other color on the
site derives from them. Do not introduce new hexes without updating this table.

| Token | Hex | Role |
| :--- | :--- | :--- |
| `--ground` | `#F2EBDD` | Bone-parchment. Default page background. |
| `--ground-deep` | `#E7DDC9` | Deeper parchment. Alternating section bands. |
| `--text` | `#2A211B` | Oud-brown ink. Body + headlines. |
| `--text-soft` | `#6B5D50` | Muted ink. Secondary copy, captions. |
| `--accent` | `#9C5B4E` | Clay-rose. CTAs, links, eyebrows. The one bold color. |
| `--accent-2` | `#B89B6E` | Warm sand-gold. Data labels, numerals, hairline highlights. |
| `--line` | `#CDBFA6` | Hairline rules and card borders on parchment. |
| `--night` | `#241C16` | Warm near-black. Footer + closing "invitation" band. |

Rule: clay-rose (`--accent`) is the only saturated color on the page. Everything else is a
warm neutral. If a section feels loud, the fix is removing accent, not adding another color.

### 1.3 Typography

Three roles. Arabic display is the lead voice.

| Role | Stack | Use |
| :--- | :--- | :--- |
| **Arabic display** | Amiri / Scheherazade New / Noto Naskh Arabic, serif | All Arabic headlines, protocol names, signatures. Set large. |
| **Latin display/body** | Iowan Old Style / Palatino / Book Antiqua, serif | English headlines and all body copy. |
| **Utility** | Optima / Gill Sans / system sans | Eyebrows, labels, nav, data, meta — anything `letter-spacing`'d and uppercased. |

Production note: the mockup uses native font stacks (no web fonts) so it renders without
external requests. For the real site, **self-host** Amiri + a licensed Latin serif (e.g.
Freight Text, Newsreader) — do not hot-link Google Fonts (PDPL/privacy + performance).

Type rules:
- Arabic headline always larger than its English partner. English headlines are italic when
  they sit under an Arabic line, to read as a subtitle, not a competing headline.
- Eyebrows/labels: utility sans, ~0.7rem, `letter-spacing: 0.3em`, uppercase, clay-rose.
- No more than two type sizes competing in any one section.

### 1.4 Layout & structure

- **Centered, single-column editorial spine.** Wide margins. Content max-width ~1180px.
- **Alternating bands**: `--ground` and `--ground-deep` mark section rhythm without rules
  or boxes.
- **The seam** (the one signature device): a faint vertical hairline down the hero center —
  two languages, one origin. Use it once, in the hero only. Don't repeat it; a signature
  used twice stops being one.
- **Numbered markers (01/02/03)** are allowed *only* where order is real: the three
  promise pillars and the four-step patient journey (Inquire → Consult → Plan → Treat).
  Not on the protocol grid (those are peers, not a sequence).

### 1.5 Motion

One orchestrated moment, then restraint.
- **Hero**: a slow staggered reveal on load (label → Arabic H1 → English → CTA). ~1s ease.
- **On scroll**: sections fade up gently as they enter. Single effect, low travel (~24px).
- **Hover**: protocol cards lift slightly; CTAs nudge up 2px. Nothing else moves.
- No autoplay sound, no carousels that auto-advance, no countdown timers, no parallax.
- Everything wrapped in `prefers-reduced-motion: reduce` → no motion.

### 1.6 Copy voice

- Bilingual, Arabic first, English as the quiet echo.
- The doctor speaks in first person ("I founded NeuSkin because…"), signed «د. ميساء».
- CTAs are always **Inquire / استفسري** or **Request / اطلبي** — never "Book Now."
- No urgency words. No "limited," no "offer," no exclamation marks.
- Honesty as a trust device: "This protocol is not for everyone — and that is intentional."

---

## Part 2 · Tech Direction

### 2.1 The decision: Hotwire monolith, not API + React

This is an editorial, content-led site of ~15 page types with very little client state.
Its commercial job is SEO capture (Journal, Treatment-outcome pages) and funnelling to a
WhatsApp/inquiry conversion. That profile points clearly at a **server-rendered Rails
monolith with Hotwire (Turbo + Stimulus)** — not a decoupled JSON API with a React SPA.

Why Hotwire wins here:
- **Arabic-first SEO** — Turbo serves real server-rendered HTML; no hydration tax, no SPA
  SEO workarounds. The pages that must rank actually rank.
- **`dir="rtl"` is trivial server-side** — Rails sets `dir` + `lang` on the layout per
  locale and the whole page flips. No threading direction through component props.
- **One language, one mental model** — Ruby + ERB + a little Stimulus. No esbuild/React
  pipeline, no Rails↔React serialization boundary, no second place for design tokens to drift.
- **Minimal client state** — nothing on the site needs a client store, optimistic UI, or
  real-time. (See 2.4: every "interactive" piece is a small Stimulus controller.)

**When to revisit React:** only if a later phase adds a genuine *app* — a logged-in patient
portal with live treatment timelines, a real-time concierge chat, a stateful dashboard.
Nothing in the current 15-page architecture is that. Build the brochure site on Hotwire now;
reconsider only if a stateful portal lands later.

### 2.2 ⚠️ The existing scaffold is configured the wrong way for this

The Rails 8 app already in this folder was generated as a **headless API**:

- `config.api_only = true` in `config/application.rb`
- `rack-cors` + `jwt` in the Gemfile (cross-origin, token auth — the SPA-backend pattern)
- No `turbo-rails`, `stimulus-rails`, `importmap-rails`, or an asset pipeline
  (`propshaft`/`sprockets`) in the lockfile
- `app/views` is empty except mailer layouts; `routes.rb` has only the health check

That is the **opposite** of the architecture we just chose. Before any page work, the app
must be converted from API-only to a full-stack Hotwire monolith. Concretely:

1. Remove `config.api_only = true` (let it regenerate full middleware — sessions, flash,
   cookies, content-type negotiation).
2. Add gems: `propshaft`, `importmap-rails`, `turbo-rails`, `stimulus-rails`. Add
   `tailwindcss-rails` *only if* we choose Tailwind (open question 2.7).
3. Drop `rack-cors` and `jwt` unless a real cross-origin/API consumer exists (none does yet).
   Keep them only if there's a confirmed external client.
4. Generate the app layout, `app/javascript` (importmap pinned), and a Stimulus
   `controllers/` directory.
5. Keep what's good and already here: Postgres, **Solid Queue/Cache/Cable**, Sidekiq,
   Kamal + Docker deploy, RSpec/FactoryBot/Faker, Brakeman, rubocop-omakase.

This is a config decision with real consequences, so it's flagged here rather than assumed.
**Do not start building views until this conversion is agreed and done.**

### 2.3 Target stack

| Layer | Choice |
| :--- | :--- |
| Framework | **Rails 8** (already scaffolded), full-stack (not api_only) |
| Views | **ERB + ViewComponent** for repeated units (protocol card, pillar, section header, patient-voice) |
| Interactivity | **Turbo (Drive + Frames + Streams) + Stimulus** |
| Assets | **Propshaft + importmap** (no Node build step needed) |
| Styling | Design tokens as **CSS custom properties** (Part 1.2/1.3), shared by every view |
| i18n | **Rails i18n** — `ar` (default for KSA/Gulf IP) + `en`; locale in URL or cookie |
| Background | **Solid Queue** (already present) for inquiry notifications, email |
| DB | **Postgres** (already configured) |
| Deploy | **Kamal + Docker** (already configured) |
| Testing | **RSpec + FactoryBot + Faker** (already present); system specs via Capependa for the funnel |

### 2.4 Interactivity inventory — all Stimulus, zero React

Proof that no React is needed. Each interactive piece and its Stimulus footprint:

| Feature | Page | Implementation |
| :--- | :--- | :--- |
| Header solidify-on-scroll | Global | `header_controller` — toggle a class past 40px scroll |
| Hero reveal-on-load + scroll fade-up | Global | `reveal_controller` — IntersectionObserver; respects reduced-motion |
| Language toggle (AR ⇄ EN) | Global | Plain link to the locale-switched URL; no JS state |
| Protocols "I'm here because…" filter | Protocols Hub | `filter_controller` — on `change`, show matching card or route |
| Bridal date-picker → days-remaining countdown | Bridal Concierge | `countdown_controller` — `<input type="date">` + date math |
| Inquiry form (KSA `+966` lock, validation) | Contact / Inquiry | `phone_controller` + native validation; **Turbo** handles submit |
| FAQ search + accordion | FAQ | `<details>`/`<summary>` + `faq_search_controller` to filter |
| WhatsApp tracked links + codewords | Everywhere | Server-rendered `wa.me` links with per-protocol codeword + UTM |

None of these hold shared state or need a client store. That is the whole argument.

### 2.5 Page-by-page build map

`R` = static-ish Rails view · `R+S` = Rails view + a Stimulus controller · component = ViewComponent.

| # | Page | Route | Build |
| :--- | :--- | :--- | :--- |
| 01 | Homepage | `/` | `R+S` — hero reveal, protocol-card + pillar + voice components |
| 02 | About / The Clinic | `/the-clinic` | `R` — patient-journey 4-step component (shared with protocol pages) |
| 03 | Dr. Maysa | `/dr-maysa` | `R` — the most important page; long-form, video embeds, credentials bar |
| 04 | The Medical Team | `/the-team` | `R` — team-member component grid |
| 05 | The Maysa Method™ | `/maysa-method` | `R` — philosophy; 12-month timeline graphic |
| 06 | Protocols Hub | `/protocols` | `R+S` — "I'm here because…" filter |
| 07a–f | Protocol pages | `/protocols/:slug` | `R` — one ViewComponent template, six data records |
| 08 | Treatment outcomes | `/treatments/:outcome` | `R` — SEO pages; route to owning protocol |
| 09 | Private Care (VIP) | `/private-care` | `R+S` — gated, unlisted; application form (Turbo submit) |
| 10 | Bridal Concierge | `/bridal-concierge` | `R+S` — date-picker countdown; lead-magnet email gate |
| 11 | Contact & Inquiry | `/inquire` | `R+S` — the conversion page; phone validation, Turbo form |
| 12 | Journal | `/journal`, `/journal/:slug` | `R` — editorial grid; bilingual posts; SEO-critical |
| 13 | Patient Stories | `/stories` | `R` — empty-state until consented material exists |
| 14 | FAQ | `/faq` | `R+S` — search + accordion |
| 15 | Legal | `/privacy` etc. | `R` — PDPL, medical disclaimer, terms; cookie consent banner |

### 2.6 Data model (first pass)

Most content is editorial. Likely models:

- **Protocol** — slug, name (ar/en), promise, duration, persona, codeword, scope stages,
  what's-not-included, FAQ (top 5), one consented story. Six rows. Drives 07a–f + homepage grid.
- **TreatmentOutcome** — slug, outcome name, owning Protocol, copy, FAQ. Drives page 08 + SEO.
- **TeamMember** — name, title, certs, focus, bio, portrait, sort order.
- **JournalPost** — title/body (ar/en), category (Educate/Reveal/Feel/Notes), author,
  reading time, hero image, related Protocol, published_at.
- **PatientStory** — initials, protocol, quote, consent-log reference, optional before/after.
- **Inquiry** — name, mobile, email, locale, persona, preferred contact time, source codeword,
  created_at. The conversion record; triggers a Solid Queue notification.
- **Translations** via Rails i18n / Mobility for model attributes. Editorial copy lives in
  the DB so it can change without a deploy; UI chrome lives in `config/locales`.

PDPL note: `Inquiry` holds personal data. Minimise fields (the architecture caps the form at
6), encrypt at rest where sensible, define a retention policy, and log consent.

### 2.7 Open questions (decide before/at build kickoff)

1. **Tailwind, or hand-rolled CSS on the tokens?** Recommendation: hand-rolled CSS with the
   committed custom properties — this design is spare and bespoke; Tailwind utility soup
   would fight the editorial restraint and the RTL flipping. Tailwind only if the team
   strongly prefers it (then use logical properties for RTL).
2. **Locale in the URL (`/ar`, `/en`) or cookie + `Accept-Language`?** Recommendation:
   path prefix (`/ar/...`) — better for SEO and shareable links; default to `ar` for
   KSA/Gulf IP, `en` otherwise, toggle always one tap away.
3. **Confirm the API-only conversion (2.2).** This is the gating decision.
4. **Web fonts**: confirm we self-host Amiri + a licensed Latin serif (no Google Fonts hot-link).
5. **Inquiry → WhatsApp handoff**: desktop visitors can't tap `wa.me` easily — add a
   "show QR / send link to my phone" fallback on the inquiry page.

---

## Part 3 · What's next

1. Agree the API-only → Hotwire monolith conversion (2.2) and the open questions (2.7).
2. Convert the scaffold; stand up the app layout, tokens, i18n, and a base set of
   ViewComponents (section header, protocol card, pillar, patient voice, patient-journey).
3. Build the homepage first (it exercises most components), then Dr. Maysa, then the
   protocol template — those three prove the system holds across page types.
4. Layer in the SEO pages (Journal, Treatment outcomes) and the conversion page last.

Reference mockup (homepage, this direction applied):
https://claude.ai/code/artifact/a129ce55-4a59-41fd-8cc3-2df5a72da733

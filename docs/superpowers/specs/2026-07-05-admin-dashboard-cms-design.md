# NeuSkin Admin Dashboard (CMS) — Design

**Date:** 2026-07-05
**Status:** Approved for planning
**Author:** ehab fayed (with Claude)

## 1. Problem & Goal

NeuSkin is a server-rendered Rails 8 site whose page copy is hardcoded directly
in ERB views (e.g. the home hero string `"Skin, measured. Confidence, quiet."`
lives inline in `app/views/pages/home.html.erb`). There is no way for a
non-developer to edit the site.

**Goal:** a server-rendered `/admin` dashboard, inside this same Rails app, that
lets an authenticated **non-technical editor** change **every line** of copy and
every image across the whole public site, in both Arabic and English, without
touching code. The public ERB views are rewired to read their content from the
database.

Reference: the `top_brand` project (`/home/efayed/milaknight/top_brand`) — its
`Section` → `Content(key/value_ar/value_en)` model and singleton `CompanyDatum`
are the proven pattern we adapt. Unlike top_brand (a headless JSON API with a
separate SPA), NeuSkin's dashboard is **server-rendered in the same app**.

### Non-goals

- No separate frontend SPA, no JSON API namespace.
- No public-facing behavior or visual change on first deploy (a seed loads all
  current copy into the DB so the site looks identical).
- No unrelated refactoring of the existing public views beyond swapping
  hardcoded strings for content helpers.

## 2. Decisions (from brainstorming)

| Decision | Choice |
|---|---|
| Architecture | Rails admin in the **same app** (`namespace :admin`); public ERB rewired to read DB |
| Scope | **Whole site** — every page editable, delivered page-by-page |
| Content model | **Hybrid** — `Content` rows for flat text, JSONB for repeating groups, `settings` JSONB for short config |
| Auth | **Devise** (new gem) |
| Editing UX | **Plain bilingual forms** (EN + AR side by side), Turbo/Hotwire — optimised for a **non-technical editor** |

## 3. Existing conventions to follow

- **Bilingual:** paired `_ar` / `_en` columns; `I18n.locale == :ar` selects Arabic.
  The `Protocol` model's locale-aware readers and the `loc(ar:, en:)` helper are
  the pattern.
- **Test stack:** RSpec (`rspec-rails`), `factory_bot_rails`, `faker`. **Not Minitest.**
- **Assets/UI:** Propshaft + importmap + Turbo + Stimulus, `view_component`.
  No Node build step.
- **Images:** `image_processing` + `ruby-vips` present → ActiveStorage variants
  are available. Current static map lives in `ApplicationHelper::NS_IMAGES`.
- **DB:** PostgreSQL (JSONB available). Rails 8, Ruby 3.2.10.
- **Enums:** `enumerize` gem.

## 4. Data Model (hybrid)

### 4.1 `Section` — one editable block of a page

```
Section
  page          string  (enumerize; one of the site's pages — see §4.4)
  kind          string  (enumerize; the block within the page, e.g. hero, principles, quotes)
  label         string  # human-friendly name shown in admin, e.g. "Hero — top of page"
  position      integer default 0
  settings      jsonb   default {}   # short config: cta labels, personas, alt text
  items         jsonb   default []   # repeating groups: array of {key => {ar,en}} hashes
  timestamps

  has_many   :contents, -> { order(:position) }, as: :parentable, dependent: :destroy
  accepts_nested_attributes_for :contents, allow_destroy: true, reject_if: :all_blank
  has_one_attached  :image          # primary section image
  has_many_attached :gallery        # for multi-image sections (e.g. clinic hscroll)

  validates :page, :kind, presence: true
  validates :kind, uniqueness: { scope: :page }   # one block of each kind per page
```

- `Section.for(page, kind)` — memoized finder used by public views; returns a
  null-object-ish Section (blank) when missing so views never crash.

### 4.2 `Content` — one editable line/field

```
Content   (polymorphic, mirrors top_brand)
  parentable_type / parentable_id   # → Section
  key           string   # stable identifier, e.g. "headline", "subtext"
  label         string   # human-friendly field name shown in admin, e.g. "Headline"
  hint          string   # optional helper text under the field in admin
  value_ar      text
  value_en      text
  content_type  string   (enumerize: text | richtext | plain) default "text"
  position      integer default 0
  timestamps

  belongs_to :parentable, polymorphic: true
  validates :key, presence: true

  def value   # locale-aware reader, like Protocol
    I18n.locale == :ar ? value_ar.presence : value_en.presence
  end
```

### 4.3 Modeling rule (hybrid — the recommendation)

- **Flat text** (headline, subtext, eyebrow, CTA line) → **`Content` rows**, one per line.
- **Repeating groups** (the 3 home quotes, 5 clinic gallery shots, principle cards,
  team members, FAQ items, treatment outcomes) → **JSONB `items`** array on the Section:
  `[{ "quote": {"ar":"…","en":"…"}, "by": {"ar":"…","en":"…"} }, …]`.
- **Short config / non-copy** (CTA button label, target persona, image alt) → **`settings`** JSONB.
- **Images** → ActiveStorage `image` / `gallery` attachments, with the current
  static asset as fallback during migration.

Worked example — **home hero**:
```
Section(page: "home", kind: "hero", label: "Hero — top of page", image: portrait_natural)
  Content(key: "eyebrow",  label: "Eyebrow (small line above headline)", value_en: "Doctor-led · Riyadh")
  Content(key: "headline", label: "Headline", content_type: "richtext")   # the three masked lines
  Content(key: "subtext",  label: "Sub-text under headline")
  settings: { cta_label: {ar,en}, cta_persona: "unsure", cta_codeword: "METHOD" }
```
Worked example — **home "In their words"** (repeating):
```
Section(page: "home", kind: "quotes", label: "Testimonials",
  items: [ {quote:{ar,en}, by:{ar,en}}, {…}, {…} ])
```

### 4.4 `page` and `kind` enums

`page` values (one per public page):
`home, dr_maysa, the_team, the_clinic, journal, stories, faq, maysa_method,
treatments, private_care, bridal, protocols_index, legal, global`

`kind` is a flat enumerize list of every block across all pages (namespaced by
intent, e.g. `home_hero, home_principles, home_founder, home_quotes,
home_cta_band, clinic_hscroll, …`). The exact list is enumerated during the
plan, one page at a time, by reading each view. `global` page holds
site-wide data (WhatsApp text, SLA line, contact hours) — NeuSkin's equivalent
of top_brand's `CompanyDatum`.

### 4.5 First-class models (NOT folded into Section)

These are genuinely dynamic collections and keep their own CRUD:

- **`Protocol`** (exists) — full admin CRUD, including its `stages`, `faqs`,
  `patient_story` JSONB edited through structured nested forms, plus image.
- **`Inquiry`** (exists) — admin **inbox**: index + show + a `status` field
  (new column: `pending | contacted | booked | closed`). Read-only otherwise.
- **`BridalLead`** (exists) — admin inbox: index + delete + CSV export.
- **`JournalPost`** (new) — `title_ar/en, slug, excerpt_ar/en, body_ar/en
  (richtext), published_at, cover image`. Replaces the currently-static journal
  grid. Public `journal` page reads from it.
- **`User`** (new, Devise) — admin accounts with a `role` (`admin | editor`).

## 5. Authentication & Authorization

- Add **Devise**; generate `User` with `role` (enumerize: `admin | editor`).
- `Admin::BaseController < ApplicationController`:
  `before_action :authenticate_user!` then `before_action :require_staff!`
  (both roles may edit content; only `admin` manages `users`).
- Devise routes mounted outside the locale scope. Admin area is **not**
  locale-scoped (English-only chrome; content fields show both AR + EN).
- Seed one initial admin via `db/seeds.rb` / env vars.

## 6. Admin UI & Routing

```ruby
namespace :admin do
  root to: "dashboard#index"                     # counts + recent activity
  resources :pages, only: [:index, :show]         # page → list its sections in order
  resources :sections, only: [:show, :update]     # edit one block (nested Content + items)
  resources :protocols                             # full CRUD
  resources :journal_posts                         # full CRUD
  resources :inquiries, only: [:index, :show, :update]
  resources :bridal_leads, only: [:index, :destroy] do
    collection { get :export }                     # CSV
  end
  resource  :global, only: [:show, :update]        # site-wide settings section
  resources :users                                 # admin-only
  resources :media, only: [:index, :create, :destroy]  # image library (ActiveStorage)
end
```

### 6.1 User-friendliness (a first-class requirement)

The editor is a **non-technical clinic staff member**, not a developer. The admin
must feel like editing a document, not a database:

- **Plain-language labels, never raw keys.** Every field shows its `label`
  ("Headline", "Sub-text under headline") and optional `hint` — the internal
  `key`/`kind` are never surfaced to the editor.
- **Navigate by page, the way the site reads.** Admin home → list of pages
  ("Home", "Dr. Maysa", "The Clinic"…) → a page shows its sections **in the same
  top-to-bottom order they appear on the live page**, each with its friendly label.
- **Two languages side by side, clearly marked.** English and Arabic inputs are
  paired and labelled (AR inputs render RTL). Nothing requires knowing which
  column maps to which locale code.
- **Images are drag-and-drop with a live thumbnail** of the current image and its
  fallback; no ActiveStorage jargon.
- **Repeating groups are obvious:** an "Add another" button and a per-item
  "Remove", with reordering — modelled as visible cards, not a JSON blob.
- **Safety & confidence:** inline validation, a success flash on save (Turbo, no
  full reload), a "View this page" link from every section edit screen so the
  editor can immediately see their change live.
- **Empty is safe:** clearing a field just renders empty on the site; no crash,
  no error state to fear.

### 6.2 Screens

- **Dashboard:** tiles — inquiries (by status), bridal leads, protocols, journal posts.
- **Pages index → page show:** lists that page's sections in `position` (live)
  order; each links to its edit form.
- **Section edit form:** renders the correct sub-form per section —
  a list of labelled EN/AR inputs for `Content` rows, a repeatable
  card list ("Add another" / "Remove" / reorder) for JSONB `items`, `settings`
  fields, and an image upload with current-image preview. Saved via Turbo;
  success flash, no full reload; "View this page" link.
- **Editing UX:** every editable string shows **English and Arabic side by side**,
  grouped and labelled by section. Plain `<input>`/`<textarea>`; `richtext`
  content_type uses a textarea for now (rich editor deferred).
- Admin styling: a minimal, clean, standalone admin layout (own CSS, not the
  public brand layout) so admin chrome never depends on public design — but still
  legible and pleasant for daily use.

## 7. Public Site Rewiring

- **Helpers** in `ApplicationHelper` (or a `ContentHelper`):
  - `sec(page, kind)` → memoized `Section.for(page, kind)`.
  - `sec_text(section, key)` → the current locale's `Content#value`, or blank.
  - `sec_items(section)` → the JSONB `items` array (locale resolved in view via `loc`).
  - `sec_image(section, fallback_key)` → ActiveStorage `image` URL if attached,
    else `ns_image(fallback_key)` (the existing static map) as fallback.
- **Per page:** the page's controller action loads `@sections = Section.where(page:).index_by(&:kind)`;
  the view replaces each hardcoded string with `sec_text`/`sec_items`/`sec_image`.
- **Migration order (page-by-page):** foundation → `home` → `dr_maysa` →
  `the_clinic` → `maysa_method` → `the_team` → `treatments` → `private_care` →
  `journal` (via JournalPost) → `stories` → `faq` → `legal` → `protocols` →
  `bridal` → `global`.
- **Seed task** (`rails db:seed` or `rake content:seed`): loads the current
  hardcoded copy + image references + friendly labels into Sections/Contents so
  the first deploy is visually identical. Idempotent
  (`find_or_initialize_by(page:, kind:)`).

## 8. Error Handling

- `Section.for` and all `sec_*` helpers return safe blanks (never nil-crash a
  public page) — a missing/empty section renders empty, matching a section an
  editor cleared.
- `sec_image` falls back to the static `NS_IMAGES` asset, then the brand mark.
- Admin forms: validation errors re-render the form with messages; Turbo frame
  stays in place.
- Devise handles auth failures (redirect to sign-in).

## 9. Testing (RSpec, TDD)

- **Models:** `Section` (validations, uniqueness scope, `for` finder + blank
  fallback), `Content` (`value` locale reader), `JournalPost`, `User` role,
  `Inquiry` status.
- **Helpers:** `sec_text`/`sec_items`/`sec_image` fallback behavior in both locales.
- **Admin controllers/requests:** unauthenticated → redirect to sign-in;
  authenticated editor can update a Section; only admin can manage users.
- **System (Capybara):** log in, edit the home hero headline, visit `/` → sees the
  new text; switch to `/` Arabic default → sees AR value.
- Factories for every new model via `factory_bot`.

## 10. Delivery increments

The implementation plan sequences work so it lands incrementally, each step
green and deployable:

1. **Foundation** — Devise + User; `Section` + `Content` models & migrations;
   admin layout, `Admin::BaseController`, dashboard, pages index; helpers +
   fallback logic; seed harness. (No public view changed yet — site unchanged.)
2. **Home page** — seed home sections, build its section edit forms, rewire
   `home.html.erb`. Proves the whole loop end-to-end, including the
   user-friendly editing UX.
3. **Remaining pages** — one increment per page in the migration order (§7),
   each: enumerate view strings → add `kind`s + friendly labels → seed → rewire view.
4. **First-class collections** — Protocol CRUD, JournalPost + journal rewire,
   Inquiry inbox + status, BridalLead inbox + export.
5. **Polish** — media library, users admin, CSV export, final verification pass.

## 11. Open items resolved

- Rich text deferred: `richtext` content_type stored, edited as textarea for now.
- Admin is English-only chrome; content always shows both languages.
- `global` Section replaces the need for a separate CompanyDatum singleton.

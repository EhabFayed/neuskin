# Technical SEO — what the app does, and what must be done in Cloudflare

Sept 2026. Companion to the technical SEO audit of neuskin.me. The first
section is for whoever administers the Cloudflare zone (no code involved);
the rest documents what the Rails app now guarantees. (Oct 2026 update: the
sitemap and robots.txt are hand-maintained files again — see §2 — but still
served by the app, not from `public/`, to keep the short cache.)

## 1. Cloudflare dashboard — to do (cannot be done from code)

| # | Setting | Where | Action |
|---|---------|-------|--------|
| 1 | **Managed robots.txt** (the "AI bots" robots.txt Cloudflare injects) | *Security → Bots* (or *AI Audit / AI Crawl Control*) → "Manage AI bots traffic with robots.txt" | **Turn off.** The app serves its own `/robots.txt`; Cloudflare must pass it through unchanged. |
| 2 | **Cached robots.txt** | *Caching → Configuration → Purge Cache* | After deploying this change, **purge** `https://neuskin.me/robots.txt` and `https://neuskin.me/sitemap.xml` once. Until now both were static files sent with a **one-year** `Cache-Control`, so the edge could keep an old robots.txt for months after a deploy — that is what looked like "Cloudflare changing robots.txt". Both now carry `max-age=3600`, so future changes appear within an hour. |
| 3 | **Email Address Obfuscation** | *Scrape Shield → Email Address Obfuscation* | **Turn off.** This is what rewrites `mailto:` links into `/cdn-cgi/l/email-protection#…` and creates the `https://neuskin.me/cdn-cgi/l/email-protection` URL crawlers report. The footer address is now also wrapped in `<!--email_off-->` so the rewrite is skipped even if the toggle is left on, and `robots.txt` disallows `/cdn-cgi/`. |
| 4 | *(check)* **Rocket Loader / Auto Minify / Mirage** | *Speed → Optimization* | Not required for SEO; if Rocket Loader is on and the audit flags render-blocking or duplicated scripts, turn it off — the site already defers its own JS. |

Nothing else in Cloudflare touches indexing. Cache status for HTML pages is
`DYNAMIC` (not cached), which is correct.

### For the Cloudflare admin (Arabic)

1. **robots.txt المُدار من كلاود فلير**: من *Security → Bots* (أو *AI Audit*) أوقِف خيار "Manage AI bots traffic with robots.txt". الموقع يقدّم ملف robots.txt الخاص به.
2. **مسح الكاش**: من *Caching → Purge Cache* امسح رابطي `https://neuskin.me/robots.txt` و `https://neuskin.me/sitemap.xml` مرة واحدة بعد النشر.
3. **إخفاء البريد الإلكتروني**: من *Scrape Shield* أوقِف "Email Address Obfuscation". هذا هو سبب ظهور صفحة `/cdn-cgi/l/email-protection`.

## 2. What the app now guarantees

### One URL per language
- English is the default locale and lives at the bare path (`/the-clinic`);
  Arabic lives under `/ar` (`/ar/the-clinic`). The old `/en/...` duplicates now
  **301** to the bare path, query string preserved
  (`ApplicationController#drop_default_locale_prefix`).
- Journal articles have a slug per language (`slug_en`, `slug_ar`). An article
  reached under the *other* language's slug (`/ar/journal/<english-slug>` or
  `/journal/<arabic-slug>`) **301s** to its own-language URL
  (`JournalController#show`). This was the "Arabic page opens under an English
  link and vice versa" finding: every article used to be indexable under four
  URLs, and the exported sitemap listed all four.

### hreflang / canonical
Every public page emits, in `<head>`:
```html
<link rel="canonical" href="https://neuskin.me/…">
<link rel="alternate" hreflang="en" href="https://neuskin.me/…">
<link rel="alternate" hreflang="ar" href="https://neuskin.me/ar/…">
<link rel="alternate" hreflang="x-default" href="https://neuskin.me/…">
```
The set is self-referencing on both language versions. Pages whose route
params differ per language (journal) pass the right slug through
`localize_route_params` so the Arabic alternate always carries the Arabic
slug. The header language switch uses the same mapping.

### Titles and descriptions (no more duplicates)
Resolution order per page, in `app/helpers/seo_helper.rb`:
1. The record's own meta fields — **Admin → Blogs / Protocols / Treatments /
   Devices → "Search preview (SEO)"** (new fields on protocols, treatments and
   devices; blogs already had them).
2. The page's **"Search preview (SEO)"** section — **Admin → Pages → *page***.
   Every page has one (the Legal page has three: Privacy, Medical disclaimer,
   Terms). Blank = use the default.
3. The built-in per-page default in `config/locales/en.yml` / `ar.yml` under
   `seo:`.
4. The site-wide default (`layout.meta_title` / `layout.meta_description`).

Open Graph (`og:title/description/url/image/locale/locale:alternate`,
`og:type` = `article` on journal posts) and `twitter:card` are emitted from
the same values.

### Three distinct legal documents
`/privacy`, `/medical-disclaimer` and `/terms` shared one template that
rendered *every* block on all three URLs. Each now renders only its own
document (title, sections from `config/locales` `legal.<doc>`, the
dashboard-editable opening/closing lines for that document, the consent
policy only on Privacy) and links to the other two.

### robots.txt and sitemap.xml
Both are **hand-maintained files** in `config/seo/` (`robots.txt`,
`sitemap.xml`), served verbatim by `SeoController` (routes at the top of
`config/routes.rb`) with `Cache-Control: max-age=3600, public`. The sitemap
is the Screaming Frog export supplied by the client (Oct 2026); the app no
longer builds it from the database.

- **To update either file:** replace it under `config/seo/`, deploy, then
  purge the two URLs in Cloudflare (or wait up to an hour).
- New journal posts, treatments, devices and protocols are **not** added to
  the sitemap automatically any more — add the URL to `config/seo/sitemap.xml`
  (or re-export the crawl) when content changes.
- Do **not** put `robots.txt` / `sitemap.xml` in `public/`: a file there wins
  over the route and brings back the one-year cache header that caused the
  "Cloudflare is changing our robots.txt" problem.

## 3. Deploying this change
1. `bin/rails db:migrate` — adds `meta_title_*` / `meta_description_*` to
   protocols, treatments and devices.
2. `bin/rails content:seed` — creates the blank "Search preview (SEO)" section
   on every dashboard page (idempotent; existing copy untouched).
3. Cloudflare steps in §1, then re-submit `https://neuskin.me/sitemap.xml` in
   Google Search Console.

## 4. Verifying after deploy
```sh
curl -sI https://neuskin.me/robots.txt | grep -i cache-control        # max-age=3600
curl -s  https://neuskin.me/sitemap.xml | grep -c "<loc>"             # > 0, no /en/
curl -sI "https://neuskin.me/en/the-clinic" | head -1                  # 301
curl -s  https://neuskin.me/privacy | grep -o "<title>[^<]*"           # Privacy Policy & PDPL — NeuSkin Clinic
curl -s  https://neuskin.me/ | grep -c "cdn-cgi/l/email-protection"    # 0
```
Tests: `spec/requests/seo_spec.rb` covers all of the above.

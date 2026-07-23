# Cursor animation + site motion pass — design

Date: 2026-07-23
Status: approved by user (dot + trailing ring cursor; all four motion effects)
Note: user handles git — nothing here gets committed by the agent.

## Goal

Give the NeuSkin site (dark editorial, warm near-black ground, cream type,
mauve/dusty-rose accents) a custom animated cursor and a richer sense of
motion, without fighting the existing design system (tokens in
`app/assets/stylesheets/tokens.css`, easing var `--ease-soft`, existing
`data-reveal` scroll-reveal vocabulary, Stimulus + importmap, no build step).

Every effect is disabled under `prefers-reduced-motion: reduce` and never
degrades touch devices.

## 1. Custom cursor — dot + trailing ring

- New `app/javascript/controllers/cursor_controller.js`, registered in
  `controllers/index.js`, mounted on `<body>` in
  `app/views/layouts/application.html.erb`.
- Controller injects two fixed-position elements: `.ns-cursor-dot` (small
  cream dot, tracks the pointer instantly) and `.ns-cursor-ring` (larger
  ring stroked in `--accent-dusty`, follows via lerp in a
  `requestAnimationFrame` loop).
- Hover state: while the pointer is over `a, button, [role="button"],
  input, textarea, select, label, [data-cursor="hover"]`, the ring expands
  and brightens (class toggled from `pointerover`/`pointerout` delegation).
  While pressed (`pointerdown`/`pointerup`), dot+ring contract slightly.
- Native cursor is hidden via a `html.ns-cursor-active` class
  (`cursor: none` on interactive roots) so JS-off / bail-out paths keep the
  normal cursor. Over text fields the custom pair fades out and the native
  I-beam returns.
- Activation guards (bail out entirely, leaving native cursor untouched):
  `(pointer: fine)` false, `prefers-reduced-motion: reduce`, or no
  `requestAnimationFrame`.
- Cursor elements get `pointer-events: none`, `z-index` above the intro
  splash, and `mix-blend-mode: normal` (blend modes fight the near-black
  ground).

## 2. Richer hover motion

- CSS only, in `application.css`, using existing tokens/easings:
  - Buttons/CTAs: `translateY(-2px)` lift + soft shadow on hover, settle on
    active.
  - Cards with imagery: image scales to 1.05 inside its clipped frame.
  - Nav/text links: 1px underline sweeps in from the inline-start edge
    (`transform-origin` flips under `[dir="rtl"]`).
- New `app/javascript/controllers/magnetic_controller.js` for primary CTAs
  (`data-controller="magnetic"`): element translates a few px toward the
  pointer within its own bounds, springs back on leave. Fine-pointer +
  motion-safe guarded. Applied to the floating book button and hero CTA.

## 3. Floating / ambient motion

- CSS keyframe utilities in `application.css`: `.float-slow` (gentle y
  drift, ~7s), `.float-drift` (xy drift + slight rotate, ~11s),
  `.breathe` (scale 1↔1.02, ~9s), with `.float-delay-*` stagger helpers.
- Applied to hero imagery / decorative accents on the home page.
- All wrapped in `@media (prefers-reduced-motion: no-preference)`.

## 4. Marquee strip

- New partial `app/views/shared/_marquee.html.erb` taking a list of words;
  renders one track duplicated twice (aria-hidden on the copy) inside an
  `overflow: hidden` band for a seamless CSS-keyframe loop.
- Pauses on hover; `[dir="rtl"]` reverses animation direction; hidden from
  screen-reader duplication; static (no animation) under reduced motion.
- Placed on the home page between sections with brand/treatment words.

## 5. Smooth scrolling

- Vendor Lenis (single ESM file) into `vendor/javascript/lenis.js`, pin in
  `config/importmap.rb`, drive it from a new
  `app/javascript/controllers/smoothscroll_controller.js` on `<body>`
  (rAF loop; destroyed on disconnect so Turbo navigations stay clean).
- Guards: only `(pointer: fine)` + motion-safe; touch devices keep native
  scrolling. Anchor links keep working (Lenis handles them).
- Fallback if the file can't be fetched in this environment: CSS
  `scroll-behavior: smooth` (motion-safe media query) and skip the library.

## Error handling / safety

- Every controller bails out cleanly when its guards fail — the site works
  exactly as today with JS off, on touch, or with reduced motion.
- No layout-affecting properties animate (only transform/opacity), so
  CLS/scroll performance is unaffected.

## Testing / verification

- Boot the app locally and load home, treatments, the-clinic pages:
  no console errors, cursor follows/expands, hovers/marquee/floats animate,
  scrolling is smooth, and everything is inert with
  `prefers-reduced-motion: reduce` emulated.
- No automated test surface exists for visual motion in this repo; changes
  are additive CSS/JS + one partial.

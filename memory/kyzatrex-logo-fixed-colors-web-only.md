---
name: kyzatrex-logo-fixed-colors-web-only
description: Kyzatrex is web-only (no iOS app); header logo IS themed via currentColor as of theme-v2 (reversing the earlier fixed-color stance)
metadata: 
  node_type: memory
  type: project
  originSessionId: 3386b40e-8536-4fec-a976-2be83175ac1a
---

Kyzatrex ships web-only — it has no iOS app, so iOS-only surfaces (modern header, native chrome) never render its assets. The web/classic header (`BrandHeaderLogo` in `components/header/brand-header-options.tsx`) sits on `bg-brand-default` and passes `color={brandHeaderContentColor}` (`neutral-50`) to the logo.

**Reversal (2026-07-10, PR #795 on theme-v2):** the header logo IS now themed via `currentColor`. On theme-v2 the header background became orange (`brand-default`), so the wordmark's baked-in `#F18756` marks blended into it. Fix: convert every fill in `assets/brands/kyzatrex/header-logo.svg` to `currentColor` (matching Thrive and the already-mostly-`currentColor` footer/mark logos) so `BrandHeaderLogo`'s `color` prop drives the whole mark. This directly reverses the 2026-07-07 "fills are contractual, never tint" stance — the context changed (orange header), and Evan explicitly directed it.

**How to apply:** brand logo fills are NOT immutable when the brand surface makes them fail. Treat the Kyzatrex header logo like Thrive's — a monochrome `currentColor` wordmark driven by the surface's chosen content color. Footer/mark logos keep their orange accent (they sit on dark surfaces where it reads). See [[dont-repave-deliberate-wiring]].

---
name: kyzatrex-logo-fixed-colors-web-only
description: Kyzatrex is web-only (no iOS app) and its logo is a defined color set — never convert its SVG fills to currentColor
metadata: 
  node_type: memory
  type: project
  originSessionId: 3386b40e-8536-4fec-a976-2be83175ac1a
---

Kyzatrex ships web-only — it has no iOS app, so iOS-only surfaces (modern header, native chrome) never render its assets. Its logo's white + orange fills are a brand-defined color set, not tintable placeholders; converting them to `currentColor` (as I did on 2026-07-07, reverted) breaks the brand mark. Contrast handling for Kyzatrex assets belongs to the surface (background choice), not the asset.

**Why:** A reviewer flagged the hardcoded white as a tinting bug; Evan corrected that the colors are contractual to the brand, and the web header will be designed separately.

**How to apply:** Treat brand logo SVG fills as immutable. If a surface can't guarantee contrast with a brand's defined colors, fix the surface or gate the brand, never recolor the asset. See [[dont-repave-deliberate-wiring]].

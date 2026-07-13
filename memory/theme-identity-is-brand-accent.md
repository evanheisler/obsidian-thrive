---
name: theme-identity-is-brand-accent
description: "The theme's identity colors are the brand/accent scales; system-* status tokens are NOT representative of the theme"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fc368b4d-cb61-4077-9eae-683551559e43
---

When something must "represent the theme's actual colors" (swatches, previews, brand surfaces), use the **brand-*** and **accent-*** token scales. The **system-*** tokens (destructive/warning/success/info) are semantic status colors — Evan: "not at all representative of the theme itself" (PR #824 theme swatch, 2026-07-13).

**Why:** system status hues are near-identical across brands/modes by design; brand + accent are what make the theme look like itself.

**How to apply:** any palette-preview or theme-representation UI draws from `brand-default/subtle/muted/strong` and `accent-*`; reach for `system-*` only when the element actually conveys status. Related: [[token-map-by-color-not-role]].

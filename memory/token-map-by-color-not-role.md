---
name: token-map-by-color-not-role
description: "When mapping a hardcoded primitive to a design-system token, match by COLOR to an existing token — never by assumed role; never add tokens"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6e076d6e-df68-4304-8b93-b0d050b322c8
---

When replacing a hardcoded Tailwind palette value (e.g. `text-blue-500`) with a design-system token, map it to the token whose **color actually matches** — `text-blue-500` → `text-system-blue-500`, because the token system HAS a `system-blue-*` scale. Do NOT map by assumed semantic role: `text-blue-500` is NOT `text-brand-default` (brand is a different color entirely).

**Why:** the design system defines system color scales (`system-blue`, `system-red`, `system-green`, `system-amber`) precisely so primitive hues have a 1:1 token home. Guessing a role mapping silently changes the rendered color.

**How to apply:** the token layer stays **1:1 with the design system — never add tokens** to force a match. If a primitive has a same-color token, convert it; if not, leaving the primitive is acceptable (some primitive use is fine — fixed media chrome, overlays). Match hue first, then check the scale step. See [[theme-v2-deprecate-non-figma-tokens]] and [[ehr-color-system-never-backported]].

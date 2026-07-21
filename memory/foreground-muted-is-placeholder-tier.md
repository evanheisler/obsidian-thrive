---
name: foreground-muted-is-placeholder-tier
description: "foreground-muted is placeholder-text-tier only — never a fill/surface, never on interactive controls; it's a known AA failure on light surfaces"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5c02e58a-3e58-4f6d-8b86-058fe9657ad6
  modified: 2026-07-20T22:09:39.139Z
---

Evan (2026-07-20, PR #847 review): "`muted` is only meant for things like placeholder
text. Using it as a surface is an incorrect carryover."

**Why:** thrive light `foreground-muted` is 72% lightness — near-invisible on light
surfaces. The token package's known-failures list already records
`thrive:light:foreground-muted:surface-*:AA` pairs as failing. Dark mode masked the
misuse (~3:1 there), so dark-only code accumulated `bg-foreground-muted` fills and
muted interactive controls that collapse in light mode.

**How to apply:** `foreground-muted` colors placeholder/disabled-tier TEXT only. For
interactive affordances (icons, dots, chevrons) use `foreground-subtle` or stronger
(≥3:1 on its background). For backgrounds, use `surface-*` tokens — a
`bg-foreground-*` class is a red flag to snap to the element's surface role. Related:
[[token-map-by-color-not-role]], [[feedback-role-first-before-design-gap]].

**Framing (2026-07-20, PR #884):** don't call muted's low contrast "over-applied" or a
token bug. The designer synced tokens to consistent values and made a deliberate call:
muted's low contrast is *accepted* for its placeholder-only role. The fix is realigning
components that used muted OUTSIDE that role — not correcting the token's value. In light
mode muted (L72%) is actually darker/more-visible than every border token, so muted-as-
border is not a contrast bug — leave it; only text/icons/chart-marks fail and move to
`foreground-subtle`.

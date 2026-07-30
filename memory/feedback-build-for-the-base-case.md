---
name: feedback-build-for-the-base-case
description: Build one shared implementation; vendor components and .native/.web splits only where genuinely required
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 84e6ad89-d822-4d81-a068-99438e58f43b
  modified: 2026-07-30T19:00:56.610Z
---

Build for the **base case**: one shared component, one behavior, both platforms. Two things are
exceptions that must be *earned*, never defaults:

1. **A vendor component (e.g. Stream's `CallControlsButton`, `CompositeButton`)** — use it only
   where the vendor genuinely requires it. For Stream video that is the video surface itself
   (`ParticipantView` / `VideoRenderer`, which carry track subscription and viewport-visibility
   signalling). Buttons, bars, pickers and layout carry none of that — those are ours.
2. **A platform override (`.native.tsx` / `.web.tsx`)** — only where the platforms actually
   diverge. Same UI + same behavior on both = one file.

Parity means each platform **looks and behaves the same**, not "each platform has its own file
kept roughly in sync."

**Why:** theming a vendor button is a workaround for rendering a component we shouldn't have
rendered. Duplicated platform files drift into spaghetti and re-litigate settled design per
surface. Evan has already had to open tickets purely to force shared componentry.

**How to apply:** before writing a `.native`/`.web` pair or reaching for a vendor UI component,
name the specific thing that forces the split. No forcing reason → build the shared one. When a
surface is found using the vendor component where ours would do, that surface is the defect —
never the standard the other should match. See [[feedback-house-rule-doesnt-override-vendor-match]]
for the narrow converse (a deliberate hand-rolled thing sitting *beside* a vendor SDK), and
[[feedback-current-shape-is-not-a-requirement]] — consolidation must delete a copy.

---
name: feedback-design-system-is-not-base-primitives
description: "\"follow the design system\" means use the right UI component for the interaction — never compose base primitives into a substitute that changes the interaction model"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-27T15:04:40.656Z
---

"Follow the design system" is about **which component renders the interaction**, not about
reaching for whatever base primitives happen to exist in `ui/`. Shoehorning `Dialog` +
`RadioGroup` + `OptionCard` into a stand-in for a dropdown is not design-system adoption —
it is a bespoke one-off wearing primitive parts, and it silently replaces the interaction
model the surface already had.

**Why:** on BH-3583 I wrote the spec that mapped patient-web video's anchored dropdowns and
`<select>`s onto `ui/dialog` / `ui/filter-selection-sheet` / `RadioGroup`-of-`OptionCard`s,
because `apps/patient/components/ui/` has no anchored-popover primitive and the app's
RN-derived filter idiom is a pill trigger + `BottomSheet`. The executor built exactly that,
turning a two-item layout toggle into a full modal with a Close button. Evan: *"'Follow the
design system' does not mean shoehorn base primitives into UI components. Use the fucking
dropdown."*

**How to apply:**
- The existing interaction model is a requirement, not a starting point. A dropdown stays a
  dropdown; a popover stays anchored. Changing it is a design decision that needs Evan
  BEFORE the spec is written, not after the PR.
- Missing primitive ≠ license to substitute a different interaction. Build (or extend) the
  right component. On patient, `components/video/anchored-popup.tsx` (PR #930) is RN-based
  and works under react-native-web — one component for both platforms, per
  [[feedback-reuse-existing-system-prove-divergence]].
- Web is not native. `apps/patient` renders both; the RN bottom-sheet idiom is not
  automatically correct on a web-only surface.
- Writing the mapping table in a slice spec is where this fails — audit each row for "does
  this change what the user does?" before it ships to an executor.

Related: [[feedback-no-single-use-abstractions]], [[feedback-bespoke-neighbor-is-not-a-pattern]],
[[feedback-visual-changes-need-a-design]], [[feedback-surface-visual-deltas-directly]].

---
name: feedback-bespoke-neighbor-is-not-a-pattern
description: "Match the design system, not the hand-rolled control next to it; a primitive's fixed size is a gap to close, never a reason to fork"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-24T20:53:15.598Z
---

When adding a control, render the `components/ui/` primitive. Existing bespoke markup in the
same file is **not** a pattern to match — copying it is how one-offs multiply. "Follow the
existing pattern" means the design system's component, not whatever the neighbouring
un-reviewed code happens to do.

Concretely, in patient native video: `Button` has an `iconOnly` variant
(`apps/patient/components/ui/button/button.tsx:29`, `h-11 w-11` at `:120`). I instead told an
executor to copy the lobby's raw `Pressable` (`w-16 h-16 rounded-full` + a shadow constant +
hardcoded `#FFFFFF`/`#000000`), then defended the 64pt size as a requirement. It had no design
source — it was just what the un-reviewed control happened to be.

**Why:** two compounding errors. I claimed `Button` was "a labeled app button" without opening
the file, and I treated its fixed `h-11 w-11` as a hard boundary to work around instead of a
gap to close. Both are the same reflex: scoping around the design system rather than through
it. Extends [[feedback-no-unverified-capability-gaps]] and
[[feedback-role-first-before-design-gap]].

**How to apply:** read the primitive's props before asserting it doesn't fit. If it genuinely
doesn't, the fix is a prop on the primitive (a design decision — park or ask per
[[feedback-shared-primitives-need-approval]]), never a bespoke fork. A dimension copied from
existing bespoke code is not a requirement; ask what the design source is before preserving
it. And "reuse component X" means render X for both purposes — cloning its markup into a
second file is the opposite. See [[feedback-reuse-existing-system-prove-divergence]],
[[feedback-no-single-use-abstractions]].

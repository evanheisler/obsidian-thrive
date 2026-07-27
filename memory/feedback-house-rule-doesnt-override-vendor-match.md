---
name: feedback-house-rule-doesnt-override-vendor-match
description: "hand-rolled UI next to a vendor SDK's chrome is usually deliberate — a repo rule like \"prefer shadcn\" never justifies replacing it; find the reason before writing the spec"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-27T16:36:49.250Z
---

When a surface renders inside a third-party SDK's own UI, our hand-built controls are often
hand-built **so they match that SDK**. Replacing them with the house component library reads
as design-system adoption and is actually a regression: the vendor's own controls cannot be
restyled, so the surface ends up with two competing looks.

**Why:** the EHR video screen's record menu, layout picker, and effects panel were styled
entirely from Stream's variables (`--str-video__base-color7`, `--str-video__text-color1`,
`--str-video__border-radius-lg`, `--str-video__spacing-*`) — the same source Stream's mic and
camera device menus read. I wrote the BH-3584 spec citing `apps/ehr/AGENTS.md`'s "always prefer
Shadcn" and listed every hand-rolled control as something to replace, without once asking why
they were hand-rolled. Result: one control bar, two menu styles, since
`ToggleAudioPublishingButton` / `ToggleVideoPublishingButton` come from Stream and we cannot
touch them. Evan: *"we used to have custom menu styling that matched Stream's components, and
we dropped it to now have 2 different menu styles?"*

**How to apply:**
- "Hand-rolled" is not evidence of a mistake. Before a spec says "replace", read what the
  existing code reads from. Styling that pulls a vendor's CSS variables is a deliberate match,
  not laziness.
- A repo convention ("prefer shadcn", "use the design system") is scoped to surfaces we own
  end to end. It does not reach a surface embedded in someone else's chrome.
- Separate the two things a rewrite bundles: **behavior** (Escape, focus return, click-outside)
  is usually the real win and can be added to the existing markup; **styling** is the part that
  regresses. Take the behavior, leave the paint.
- If a control's neighbours come from the vendor's package, that constrains us — check what is
  ours to change before proposing anything.

Related: [[feedback-dont-repave-deliberate-wiring]], [[feedback-design-system-is-not-base-primitives]],
[[feedback-reuse-existing-system-prove-divergence]], [[feedback-surface-visual-deltas-directly]].

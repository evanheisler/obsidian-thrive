---
name: feedback-rework-existing-story-single-docs
description: "Extend the existing story file for a surface, never create a parallel one; catalogs are one docs story, not per-variant stories"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e9f020b-03bd-416a-b1ca-cb38e9f58b92
---

BH-3228's executor left `typography/typography.stories.tsx` untouched and added a new `text.stories.tsx`. Evan: "827 apparently ignored the existing Typography story and created a Text story. I want one Typography story with a `docs` story (do not render individual stories per fontstyle)."

**Why:** A parallel story file duplicates the surface's catalog and orphans the old one. Per-variant story exports bloat the sidebar; a single docs story shows the whole ramp in one view, which is what design sign-off needs.

**How to apply:** When a component supersedes or covers an existing storybook surface, rework the existing story file in place. For token/variant catalogs, emit one docs story rendering all variants — no individual story per variant. When an issue offers "rework existing OR add new" ([[feedback-spec-invariants-not-just-deltas]]), instruct executors to rework the existing; check executor output for parallel-file creation like [[feedback-no-single-use-abstractions]].

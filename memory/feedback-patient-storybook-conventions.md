---
name: feedback-patient-storybook-conventions
description: "Patient stories — never the legacy `Patient/` title namespace (use `Components/`); no named story a control toggle can express, docs view is the deliverable"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fc368b4d-cb61-4077-9eae-683551559e43
---

Two rules Evan enforced on PR #824's story file (2026-07-13):

1. **Never add to the `Patient/` story namespace — it is legacy.** New patient-app stories title under `Components/` (token/foundation pages under `Design System/`), matching the `components/ui/*` stories.
2. **Do not render useless stories.** The docs view is all that's needed 9/10 times. An individual named story exists only for custom rendering; if a variant can be expressed with a Storybook control/arg toggle (e.g. `mode`, `selected`), it does not get its own story. Default shape: one `Default` story + controls.

**Why:** the sidebar and legacy namespace accrete noise; every arg-permutation story is maintenance with zero information over the docs page.

**How to apply:** when writing or reviewing a `*.stories.tsx` in `apps/patient`, check the `title:` root and delete any named story whose diff from Default is pure args. Related: [[feedback-layout-files-are-wiring-only]] (co-located story requirement), [[feedback-rework-existing-story-single-docs]] (variant catalogs = one docs story).

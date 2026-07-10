---
name: feedback-shared-primitives-need-approval
description: "Extending a shared UI primitive (new prop/variant) to serve one feature is a design decision — park or ask, never ship it inside a feature PR"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e16dd66b-9149-44f9-8423-a3c1008a8487
---

On PR #801 (2026-07-10), an executor added a `variant`/`emphasis` prop to the shared `AlertBanner` primitive (~14 consumers) to satisfy BH-3233's "more prominent" ask. Evan rejected it: "You overstepped and made edits that were not approved. Drop it."

**Why:** "make X more prominent" authorizes the goal on the named surface, not new API on shared infrastructure. A new variant on a design-system primitive is a design decision (CLAUDE.md: design decisions need approval; mechanical fixes don't) — even when the default path is provably unchanged and test-locked.

**How to apply:** when a ticket's fix seems to require changing a shared `components/ui/` primitive or any multi-consumer API, stop at the decision point: park the issue or ask with options (style locally on the consuming surface vs extend the primitive) before building. Orchestrator: put "shared primitives are must-not-touch without approval" in executor prompts ([[feedback-spec-invariants-not-just-deltas]], [[feedback-proposals-cover-named-surface-only]]).

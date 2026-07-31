---
name: feedback-invariants-protect-deliberate-not-accidental
description: "Never write blanket 'no visual change / nothing can change' invariants into PRDs or issues — protect deliberate contracts only; accidental divergence gets converged, not preserved"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cb9e81d6-18c6-4084-b925-f24cdc99090f
  modified: 2026-07-31T16:39:40.530Z
---

Blanket freeze clauses ("zero visual change", "no behavior change") in specs make executors
ignore improvements they find — during the Stream video rework, agents left web and native
handling different for no reason because the issue said change wasn't allowed.

**Why:** Evan (2026-07-31, Stream debt-sweep PRD): "Do not over-prescribe 'no visual changes'
or 'nothing can change' like you usually do… a lot of this UI consolidation was ignored
because the current state would handle web and native differently for no reason… Better,
maintainable code and a consistent UI is always the better choice than 'leave it alone'."

**How to apply:** Invariants name the *deliberate* contracts (design-system choice per app,
brand theming, copy voice, an SDK major) — never the current pixels. Accidental divergence
(platforms/apps differing for no articulable reason) is explicitly fair game: converge it to
one consistent implementation and surface visible deltas with before/after on the PR
([[feedback-surface-visual-deltas-directly]]) instead of avoiding the change. Counterweight
to [[feedback-spec-invariants-not-just-deltas]]: still state what must not change, but the
list is deliberate contracts, not a freeze.

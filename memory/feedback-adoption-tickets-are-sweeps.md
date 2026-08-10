---
name: feedback-adoption-tickets-are-sweeps
description: "A primitive-adoption ticket's named sites are examples — the contract is zero remaining derivations repo-wide"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca360ef0-3521-4f71-8a69-b3434f7f3e70
  modified: 2026-08-10T20:11:55.733Z
---

On BH-3776 (Chip at TypePill) the executor found two more hand-rolled chip-shaped controls and I asked Evan whether to ticket them. He rejected it hard: "this ticket exists already to SWEEP UP ALL THE DERIVATIONS. It was never supposed to be a fixed list."

**Why:** An adoption ticket's purpose is convergence on the primitive. The enumerated sites are where the divergence was first seen, not a fence around the work. Newly discovered derivations of the same pattern are in scope by definition — asking to ticket them re-fragments the sweep.

**How to apply:** When executing or authoring a primitive-adoption ticket, grep the whole repo (apps/ + packages/) for the pattern and fold every true derivation into the same PR. Only park a site if it can't adopt without changing the primitive. When authoring such tickets ([[feedback-spec-invariants-not-just-deltas]]), write the done-when as a repo-wide grep for the pattern, not the named files. Related: [[feedback-touching-it-makes-it-yours]], [[feedback-current-shape-is-not-a-requirement]], [[feedback-dont-dodge-endstate-to-avoid-churn]].

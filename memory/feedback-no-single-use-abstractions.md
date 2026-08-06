---
name: feedback-no-single-use-abstractions
description: Never extract a single-use component when a prop-driven shared primitive covers it — flagged anti-pattern (PR
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
  modified: 2026-08-06T15:14:40.745Z
---

Evan (2026-07-13, PR #816): extracting `my-health-data-cta.tsx` — a one-off wrapper around one Pressable+Text used once — was "an unnecessary abstraction… there is no reason to create a single use abstraction. The component should be a prop-driven Button."

**Why:** decomposition means routing UI through containers and *existing* prop-driven primitives (`components/ui/button`), not minting a bespoke component per element. A single-use extraction adds a file and a name with zero reuse or composite value.

**How to apply:** when decomposing a screen, never mint a one-off component — but in a behavior-preserving refactor, keep the raw element (original Pressable + classes) inline rather than swapping to a `ui/` primitive: Evan ruled the primitive swap "too large of a visual change" for a mechanical PR (2026-07-13). Primitive migration is its own designed issue (BH-3264: align Button with Figma, then migrate call sites). Codified as an anti-pattern in the patient conventions ([[home-revamp-toggle-user-opt-in]] project). Check executor output for it.

**Extends to constants and types, and to abstractions that *lose* their second consumer** (2026-08-05, PR #997): a 3-line `my-health-tabs.ts` holding one `as const` array plus its derived type was legitimate while two files imported it, and became a single-use module the moment the second consumer was dropped from the PR. I called the file-vs-inline placement "cosmetic"; Evan: "it sets a precedent that agents follow blindly." **The cost isn't the file — it's that a single-use module sitting in an open PR reads as sanctioned house style and gets copied.** So when scope shrinks, re-check every extraction the removed code justified; `git grep` the symbol and count *real* importers before defending it. Same test when salvaging work out of an abandoned branch: an extraction that deduplicated A against B is dead weight once B is gone.

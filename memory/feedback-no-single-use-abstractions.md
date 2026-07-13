---
name: feedback-no-single-use-abstractions
description: Never extract a single-use component when a prop-driven shared primitive covers it — flagged anti-pattern (PR
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
---

Evan (2026-07-13, PR #816): extracting `my-health-data-cta.tsx` — a one-off wrapper around one Pressable+Text used once — was "an unnecessary abstraction… there is no reason to create a single use abstraction. The component should be a prop-driven Button."

**Why:** decomposition means routing UI through containers and *existing* prop-driven primitives (`components/ui/button`), not minting a bespoke component per element. A single-use extraction adds a file and a name with zero reuse or composite value.

**How to apply:** when decomposing a screen, never mint a one-off component — but in a behavior-preserving refactor, keep the raw element (original Pressable + classes) inline rather than swapping to a `ui/` primitive: Evan ruled the primitive swap "too large of a visual change" for a mechanical PR (2026-07-13). Primitive migration is its own designed issue (BH-3264: align Button with Figma, then migrate call sites). Codified as an anti-pattern in the patient conventions ([[home-revamp-toggle-user-opt-in]] project). Check executor output for it.

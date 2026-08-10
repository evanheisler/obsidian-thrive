---
name: rules-encode-the-test-not-verdicts
description: "A skill rule that needs a settled-case list is brittle — write the single generative question that produces the rulings, keep examples as illustrations only"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-10T20:27:40.723Z
---

The storybook-stories skill was amended three times (#1011, #1028, plus a proposed third) because each ruling (BiomarkerFilters, TasksDueBanner, DocumentSkeletonList) was encoded as its instance — named components in settled-case lists, structural proxy tests ("wrapper?", "zero props?", "stands on its own?"). Every new ruling contradicted a named example and forced another amendment. Evan: "Think critically about what the design is supposed to accommodate and stop writing such brittle rules."

**Why:** Structural tests are proxies for the semantic question the design actually asks, and every proxy leaks on the next case. A rule that requires enumerated verdicts to be applied is not a rule — it is a cache of past decisions that goes stale the moment a new case arrives.

**How to apply:** When encoding a correction into a skill, first derive the single generative question that produces ALL the rulings to date (for the storybook sidebar: "does this component introduce design decisions of its own, or apply another component's?" — new decisions earn an entry at the tier matching their scope; applications — presets, domain bindings, loading/empty/error states, instances — document on the owning entry's page). Verify the question decides every settled case before writing it. Length itself is brittleness (Evan, 2026-08-10, on the 257-line rewrite: "extremely verbose… not adding worthwhile content"): state each rule exactly once, never restate it across sections or in the done-when checklist, cut worked illustrations entirely — the operational tell (e.g. the strip test) replaces them — and cut all persuasion prose; a skill instructs a future agent, it does not argue with one. Related: [[feedback-storybook-entries-are-earned-not-migrated]], [[feedback-serve-the-rules-purpose]].

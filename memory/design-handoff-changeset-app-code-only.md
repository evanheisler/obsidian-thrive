---
name: design-handoff-changeset-app-code-only
description: "A design-handoff branch carries ONLY the converted app code — derivation tooling, bundle HTML, manifests, and lint-config tweaks for scripts never ride it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-11T20:37:58.369Z
---

BH-3725 spike (2026-08-11): the pushed branch mixed the ChoiceCard conversion with the card
extractor script, an eslint.config change for it, and the design-sync bundle (HTML cards,
manifest.json, FORMAT.md). Evan: "none of that is relevant to the app. I don't want those
artifacts to be included if they are not required… I am calling it out so the workflow knows
how to handle this."

**Why:** The reviewable changeset is the product delta. Derivation tooling belongs to the
builder issue that productizes it ([[feedback-conventions-before-machinery]] — BH-3726 in the
Claude Design workflow); bundle artifacts already live in the Claude Design project, so repo
copies are duplication.

**How to apply:** When converting a Claude Design handoff (or building any design-sync bundle),
the branch/PR contains only `components/proposed/<design-slug>/` code and stories. Extraction
scripts, bundle output, and config tweaks that serve them stay out — archive locally
(un-pushed branch) if a later issue needs them as input. Write this rule into the BH-3728
handoff skill and the BH-3726 dispatch brief when those build.

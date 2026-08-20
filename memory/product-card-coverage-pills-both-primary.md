---
name: product-card-coverage-pills-both-primary
description: "Both med-selection coverage pill states (included / additional) use the primary Badge treatment — no new variant, no per-state styling"
metadata: 
  node_type: memory
  type: project
  originSessionId: 728d7897-0a73-47cd-ba19-dd41ef5db2dd
  modified: 2026-08-20T21:11:39.917Z
---

Evan's design ruling (2026-08-20, BH-3842 / PR #1099): the product-card coverage pill renders the **same `primary` Badge treatment for both states** ("Medication included" and "+ cost of medication"). Do not invent a new Badge variant for it, and do not arbitrarily diverge the two states' styling — only the label text differs. Supersedes the bot-review `neutral` swap and the ticket's "solid green vs muted dark" reading of the mockups. He also ordered the `kind` (`included`/`additional`) discrimination deleted end-to-end — `medicationCoverage` is a plain optional string rendered in the pill; no state modeling. Related: [[feedback-shared-primitives-need-approval]], [[feedback-visual-changes-need-a-design]].

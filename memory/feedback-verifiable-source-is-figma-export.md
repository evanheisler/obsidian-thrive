---
name: feedback-verifiable-source-is-figma-export
description: A token baseline generated from the implementation is not a spec — the source-of-truth artifact must be a raw Figma export
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e9f020b-03bd-416a-b1ca-cb38e9f58b92
---

The color token layer (theme-v2) was grounded in a **direct Figma export JSON** checked into the repo — a verifiable source of truth ([[feedback-ingest-matches-raw-artifact]]). The type token layer (BH-3227, PR #823) was built from hand-transcribed spec tables in the issue (from a UI artboard, Figma node 6979-780), and its `type-tokens.baseline.json` was **generated from the implementation** — a snapshot of code, not a source artifact. Evan: "The JSON it's based on is a direct export from Figma — a verifiable source of truth. Your generated JSON is a representation of a UI artboard."

**Why:** A self-generated baseline is circular — it pins the code against itself and can only catch future regressions, never a wrong initial transcription. "Figma lockstep" requires the checked-in artifact to originate in Figma.

**How to apply:** When a token/design layer claims Figma as source of truth, the repo artifact must be a raw Figma export (variables/styles export or MCP pull), and tests should verify the implementation against that artifact. Hand-transcribed tables and implementation snapshots don't qualify. Flag this gap in specs before dispatch, not after shipping.

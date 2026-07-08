---
name: feedback-ingest-matches-raw-artifact
description: "Ingestion code must accept the raw artifact a human repeatedly drops in (exact filenames included), and infra ships with a README — no hidden manual steps"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

On theme-v2 codegen (PR #786), Evan flagged two defects: `read-design.ts` expected
normalized filenames (`thrive-light.tokens.json`) while Figma exports `Thrive
Light.tokens.json` — I had renamed files by hand at check-in, silently inserting a manual
step into the designer re-export workflow — and the codegen shipped with zero
documentation.

**Why:** for any recurring human-in-the-loop ingest, the raw artifact as the tool emits it
IS the contract. A hand normalization step is hidden brittleness that fires on the second
iteration, on someone who isn't me. And infrastructure without a README (how it works, the
update workflow, naming conventions, error meanings + who resolves each) isn't done.

**How to apply:** when building ingestion/codegen around an exported artifact, make the
code accept the exporter's raw output drop-in (normalize internally, fail loudly on true
ambiguity) and include a README covering mechanism, update workflow, conventions, and
error handling. Related: [[feedback-shared-docs-stay-machine-agnostic]],
[[theme-v2-deprecate-non-figma-tokens]].

---
name: feedback-no-workflow-comments-in-app-source
description: "Never annotate app source with CI/workflow plumbing comments (e.g. 'this line is parsed by script X') — Evan: 'Don't litter app.config with workflow noise'"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 146b8967-b69b-4150-b2a6-4237557236b1
  modified: 2026-08-20T15:47:26.300Z
---

BH-3916's executor added a comment above `version:` in `apps/patient/app.config.ts` explaining
that `scripts/parse-patient-release-tag.mjs` reads the line as a literal. Evan: "Don't litter
app.config with workflow noise. That comment is useless — WE ALREADY KNOW THE VERSION IS LOAD
BEARING."

**Why:** The version field is obviously load-bearing; the comment restates plumbing that lives
(and is test-guarded) in the consuming script. Cross-references to tooling belong in the tool,
not the source it parses. Same class as the CLAUDE.md comment allowlist — [[feedback-serve-the-rules-purpose]].

**How to apply:** When a workflow/script parses an app-source line, keep the explanation and
drift guard in the script and its tests. Add nothing to the parsed file. Audit executor diffs
for this before reporting shipped — a "helpful" anchor comment in app code is a defect.

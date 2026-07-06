---
name: feedback-pr-descriptions-short
description: "Evan wants PR descriptions short — verbosity is my drafting habit, not the write-pr skill's structure"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d50bfc6c-34ce-4daf-ba04-c11f52520403
---

Evan: "Shorter. I never like your PR descriptions." (2026-07-06, GTM PR)

**Why:** Reviewers read the diff; the PR body should carry only what the diff can't say. Long bodies bury the one design call that matters.

**How to apply:** On top of the [[write-pr]] skill's Why/Behavior/Test plan structure: 1–2 sentence Why; 2–3 tight Behavior bullets (the non-obvious design call, not a change inventory); minimal test plan; drop optional sections unless essential. No verification narration, no restating what code comments already say.

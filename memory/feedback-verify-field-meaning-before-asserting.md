---
name: feedback-verify-field-meaning-before-asserting
description: "Confidence in what an API field means is not a receipt — look it up before reporting a defect from it, and re-check before repeating the claim"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1f7bfb7a-e2aa-43c7-916d-124f74e54193
  modified: 2026-08-19T15:42:35.391Z
---

Before asserting a defect from an API response field, verify what the field actually means.
Knowing the field name is not knowing its semantics, and a wrong reading published as a finding
is a fabricated defect.

**Why:** I reported five PR comments as "stranded at the top of the file" because the GitHub
review-comment API returned `line: null` and `position: 1`. Neither means that. `line: null` with
`original_line` populated marks a comment **outdated** — the author pushed commits that moved the
line — and `position` is a stale offset into the original diff, not a render location. The
comments had posted correctly. Evan had already resolved them.

**How to apply:** a field-derived claim needs the same receipt as any other (core rules §8) —
docs fetched this turn, or the observable behavior. Two tells I ignored: the null count changed
between readings (5 → 6), which alone disproved "stranded" and proved a moving head; and I
repeated the claim a turn later without re-checking, so it was stale as well as wrong. Re-verify
a claim about live external state before every re-assertion, not once.

See [[feedback-red-check-is-not-green]] and [[feedback-verify-branch-protection-before-blocker]]
for the same failure — inferring a state instead of reading it. Related:
[[feedback-instrument-dont-use-evan-as-sensor]].

---
name: feedback-gate-covers-publication-not-ci-fixups
description: "Approval-gated review covers the review-response commit + GitHub replies, not mechanical CI fixups on my own already-approved change"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7d99dd87-fa90-4d67-896e-2bbee4335a8e
---

Under approval-gated-code-review, the gate covers *publication of review responses*:
the review-feedback commit/push and the GitHub replies/resolutions. It does NOT
re-gate a follow-up mechanical fix (lint/typecheck/CI failure) on code Evan already
approved. When my own approved change fails CI, fix it, verify, and push — don't stop
for approval on a syntax-level fixup.

**Why:** Re-asking "approve this lint fix?" after Evan already approved the change is
noise; it treats a mechanical correction as a new decision. Mirrors the standing rule
"design decisions need approval; mechanical fixes don't" ([[feedback-dont-repave-deliberate-wiring]]).

**How to apply:** After a gated commit lands, if CI fails on that commit, diagnose + fix +
verify + push in one pass. Reserve the stop-and-ask for a NEW review-feedback response or
a genuine design choice, not for making my own approved diff green.

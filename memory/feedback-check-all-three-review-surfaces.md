---
name: feedback-check-all-three-review-surfaces
description: PR feedback lives on three GitHub surfaces; an unresolved-thread count alone is a false negative
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2b342afe-cc25-445e-9d43-423bfae3d26c
  modified: 2026-07-31T20:39:50.026Z
---

GitHub PR feedback lives on three independent surfaces: **review bodies**
(`pulls/<n>/reviews`), **issue comments** (`issues/<n>/comments`), and **inline review
threads** (GraphQL `reviewThreads`). A review submitted with a body and zero inline
comments creates **zero threads** — so an unresolved-thread count returns `0` while a
long human review sits unread.

**Why:** during a `/work-project` run I reported #959 and #952 as "0 unresolved
threads, awaiting your validation pass" while each carried a multi-thousand-character
body-only review from a teammate. Evan caught both. The failure was a measurement bug,
not a judgment call — I queried one surface and reported a conclusion about three.

**How to apply:** never write "clean" / "no feedback" / "0 unresolved" off a thread
count. Query all three surfaces per PR, per cycle. Only threads carry a resolve state,
so for bodies and comments "handled" means a reply post-dating them — when unsure
whether an old body was addressed, dispatch a handler to verify against the tree rather
than assume. Also: a re-derive is a snapshot, not polling — arm a persistent watch or
you are blind between turns. Codified in `work-project` SKILL.md.

Related: [[work-project-verify-bot-reviews-yourself]],
[[feedback-read-full-pr-feedback-every-cycle]], [[feedback-orchestrator-delegates-review-loop]]

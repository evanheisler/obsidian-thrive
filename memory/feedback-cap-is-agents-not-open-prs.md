---
name: cap-is-agents-not-open-prs
description: "work-project pool cap bounds CONCURRENT EXECUTORS, not open PRs — never halt dispatch because PRs are sitting in the review queue"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Evan (2026-07-17), after I held the last four burndown slices because four agent PRs were open: "Why is work halted due to PRs open? The pool is for agents."

**Why:** Open draft PRs cost nothing while they wait — they are the loop's output buffer, not consumed pool slots. Treating the review queue as the pool's binding constraint stalls the whole project on human merge latency, which is exactly what the AFK loop exists to decouple.

**How to apply:** Fill the pool whenever a ready (or stackable) issue exists and executor slots are free. Count only running executors against the cap. Merge-queue depth is Evan's to manage; stack-depth (~3) and true Blocked-by are the only structural dispatch limits. Related: [[feedback-no-arbitrary-backoff]], [[work-project-verify-bot-reviews-yourself]].

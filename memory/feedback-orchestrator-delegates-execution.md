---
name: orchestrator-delegates-execution
description: "In an orchestration loop (work-project), all hands-on execution — including addressing PR review feedback — goes to a subagent; the orchestrator never edits files inline"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

When running /work-project (or any orchestration loop), do not do execution work inline — dispatch it. Evan (2026-07-16), after I started editing lint config files myself to address PR #840's review threads: "Run it in a sub agent dumbass you are an orchestrator."

**Why:** Inline execution burns the orchestrator's context on file-level detail, serializes the loop behind one PR's fixes, and mixes roles — the orchestrator's job is state derivation, dispatch, gating, and reporting.

**How to apply:** For review-feedback work under an approval-gated flow, dispatch a subagent to do the WHOLE pass — fetch the PR's threads, evaluate technically, fix locally in the PR's worktree, verify — and STOP, returning changed files, verification output, proposed commit message, per-item dispositions, and draft replies. The orchestrator does not even fetch the threads itself (corrected a second time 2026-07-16: "USE A FUCKING SUB AGENT" when I began the fetch inline); it dispatches on the PR number alone, relays the returned checkpoint to Evan, and executes the approved gate actions (commit/push/post). Approval gates still follow approval-gated-code-review.

**Extends to stack-rebase conflicts (2026-07-17):** "You are an orchestrator ... supposed to delegate to /subagent-driven-development. 857 has feedback you never responded to." — said after I resolved two rebase conflicts by editing worktree files myself. Dispatch conflict resolution to the owning executor too (give it the base tip + "sync to origin first"). The inline work is not free: while heads-down editing, I stopped sweeping reviewThreads and a new jellis18 thread on #857 went unanswered. Inline edits are the exception for when delegation is provably broken (API down, agents dying — see [[feedback-no-arbitrary-backoff]]'s sibling reasoning), NOT the default for "small" work. Staying out of the editor is what keeps the reviewThread sweep alive ([[work-project-verify-bot-reviews-yourself]]).

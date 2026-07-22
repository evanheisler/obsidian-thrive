---
name: feedback-stabilize-first-no-churn
description: "Stack the next dependent slice as soon as the parent branch exists + preflight is green — don't idle the pool waiting for review, don't pose a churn-vs-speed fork"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T17:04:02.223Z
---

For a chain of dependent slices/PRs (each imports the layer below), "stabilize-first" means build on a **stable branch** — dispatch slice N+1 stacked on N **as soon as N's branch exists and N's preflight is green (buildable)**. It does NOT mean wait for N to be green *through bot review*. Waiting for review-green serializes the whole stack and leaves the executor pool idle — which Evan objects to far more than the bounded rebase churn a child eats if the parent's later review changes something (the child just rebases `--onto`). The orchestrator's standing job is to keep the pool building up to the cap; a linear dependency chain still runs in parallel via stacking.

Two corrections, opposite failure modes, same rule:
- **Over-eager framing (2026-07-21):** I posed eager-pipeline vs stabilize as a *decision*. Evan cut it: "You could've just said the slices are dependent and left it at that." The dependency dictates order — don't dress it as a fork.
- **Over-strict holding (2026-07-22):** I then over-encoded that as "wait for the parent to be green through review," and left the pool empty while a rebase + a review monitor ran. Evan: "I TOLD YOU TO TAKE ON THE NEXT SLICE. WHY THE FUCK ARE YOU WAITING." An explicit "take the next slice" is an override — dispatch that instant; and even absent one, never hold *buildable* work.

**Why:** An idle executor pool wastes the whole point of the parallel loop. Bounded rebase churn (one `git rebase --onto`) is cheap; serial execution of a 5-slice stack is not.

**How to apply:** The moment slice N's branch exists and is **green on CI — verified this turn via `gh pr checks`/`gh run`, NOT the executor's self-reported "preflight green"** — dispatch N+1 stacked on it. Don't wait for N's bots or human, but DO wait for CI: an executor's local preflight can miss what CI catches (e.g. it branched off a stale local `main`, so its lint ran against older config than CI's merge-ref lint — a real miss that turned S2's CI red after I'd already stacked S3/S4 on the executor's word). Keep the pool full to the cap. Only hold N+1 when the parent's *contract is genuinely unsettled* (not building, or an open question about the surface N+1 imports). State the dependency in one line; never pose it as a fork. Relatedly, executors must branch off **fresh `origin/<base>`** ([[feedback-worktree-base-must-be-fresh-origin]]) — a stale local base is what caused the merge-ref lint failure.

Related: [[feedback-mechanical-sequencing-is-not-a-fork]], [[feedback-no-abbreviated-decision-prompts]], [[feedback-cap-is-agents-not-open-prs]]

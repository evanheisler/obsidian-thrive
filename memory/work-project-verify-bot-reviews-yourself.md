---
name: work-project-verify-bot-reviews-yourself
description: "Executor bot-review polls stall silently; orchestrator must verify claude+codex reviews on GitHub itself and re-dispatch, never sit waiting"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e16dd66b-9149-44f9-8423-a3c1008a8487
---

During /work-project (2026-07-10, PRs #801/#803), both ship-issue executors ended their turn "standing by for the poll" and never self-resumed; bot reviews posted and sat unaddressed until Evan intervened ("you aren't doing shit"). Separately, one executor asserted "Codex never posted" from a fetch that predated the Codex comment.

**Why:** an executor's background wait is not a reliable wake signal, and a single stale fetch produces false "no review" claims. The orchestrator owns liveness.

**How to apply:** when an executor returns anything other than SHIPPED/PARKED (e.g. "waiting for bots"), treat it as stalled: poll the PR yourself (`gh api repos/<org>/<repo>/issues/<n>/comments` for the `## Codex Review` github-actions comment + claude[bot] review) and SendMessage the executor to run its review loop the moment reviews exist. Before accepting a SHIPPED that claims a bot never reviewed, re-fetch this turn and check both bots landed ([[feedback-refetch-before-asserting-state]], [[codex-review-posts-as-github-actions-comment]]).

**A review's state is body + reviewThreads, never the body alone (2026-07-17):** an APPROVE can carry actionable inline threads, and a COMMENT review's findings live in its body with no thread to signal them. Every sweep must fetch reviewThreads for every PR with any review AND read full review bodies — I dispatched nothing for 7 threads across three approved PRs until Evan caught it. Review-body findings with no thread get answered via an inline comment anchored to a relevant changed line (top-level comments are hook-blocked, including the API route).

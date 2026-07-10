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

---
name: feedback-red-check-is-not-green
description: "never call a PR \"green\" while any check is failing, even a non-required/infra one; \"not a required merge gate\" ≠ green"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1835a6ad-ab07-4c6c-9342-03bd24a8d594
  modified: 2026-08-20T15:53:01.031Z
---

I labeled PR #915 "green" in a status table while `codex-review` was failing on it, having decided the failure was a non-required, repo-wide infra break (deprecated model). Evan: "I don't know why you are ignoring the CI failure on 915. Its not green." I had conflated "won't block the human's merge" with "green."

**Why:** a failing check is a red X regardless of whether it's a required status check. Downgrading it to a footnote and reporting the PR as green hides a real signal and reads as ignoring CI. Also: assert an infra-vs-diff cause only with proof — Evan then demanded proof, which meant pulling the actual failing-job logs across multiple PRs.

**How to apply:** report a PR as green ONLY when every non-skipped check passes. If a check is red, say "red on <check> because <proven cause>", state whether it gates merge separately, and either fix it or surface it as an open item — never call the PR green. Back any "it's infra, not the diff" claim with the log line + the same failure on an unrelated PR before asserting it. Relates to [[feedback-refetch-before-asserting-state]] and [[feedback-no-fabricated-evidence]].

**Second failure mode (2026-08-20, #1093):** called a PR "ready for your merge" off CI + approvals + resolved threads while `mergeable: CONFLICTING` — the base had moved (sibling squash-merge churned the lockfile) and I never queried it. Evan: "Why the fuck are you ignoring the merge conflicts." "Ready for merge" has FOUR legs: checks green, approvals current, threads resolved, `mergeable: MERGEABLE` — query all four in the same status fetch. And when a base branch advances, sweep EVERY open PR on that base, not just the merged PR's children ([[feedback-rebase-on-merge-not-on-commit]]).

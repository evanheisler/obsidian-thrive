---
name: feedback-never-refire-bot-reviews-on-push
description: never re-fire (label-toggle) bot reviews on iterative pushes/fixes — bots review a PR ONCE; re-firing multiplies Claude+Codex runs and burns tokens + CI minutes
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9173d154-fc85-4150-b323-25665fcdc9e9
  modified: 2026-07-22T20:54:49.874Z
---

Do NOT re-request bot reviews by toggling the `claude-review`/`codex-review` labels after a push or fix. Bot review runs **once** per PR (at creation). When a fix addresses a finding: **push + reply `Addressed in <sha>` in-thread + resolve the thread** — that is the whole loop. Do NOT re-toggle labels to re-run the bots to "confirm" the fix. A reviewer sees the fix from the diff + the reply; no bot reconfirmation is needed. CI checks (tests/lint) re-run on push automatically and unavoidably — that is fine; the *bot review* is the expensive thing not to re-trigger.

**Why:** Evan — "STOP RE-REQUESTING BOT REVIEWS ON EVERY PUSH. YOU ARE BURNING TOKENS AND CI MINUTES. 8 BOT REVIEWS ON 904." My executor and fix-subagent dispatch prompts routinely instructed "re-fire the bots / cycle the review labels" after each push; with each iterative fix that ran a fresh full Claude+Codex review, so one PR accrued ~8 bot runs.

**How to apply:** strip any "re-fire / cycle the labels / re-dispatch bot review" instruction from every executor and fix-subagent prompt. The dispatch contract is: fix → push → reply-in-thread → resolve. Nothing toggles review labels after PR creation, ever. This generalizes [[feedback-no-refire-bots-after-noop-rebase]] (which was rebase-specific) to ALL pushes. Related: [[work-project-verify-bot-reviews-yourself]], [[feedback-read-full-pr-feedback-every-cycle]].

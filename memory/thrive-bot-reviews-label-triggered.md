---
name: thrive-bot-reviews-label-triggered
description: thrive PR bot reviews only run when claude-review/codex-review labels are added — add both at PR creation and verify runs dispatched
metadata: 
  node_type: memory
  type: project
  originSessionId: 6d69cf5a-a9e8-4b88-87db-e40d2cef581a
---

In Bionic-Health/thrive, `claude-code-review.yml` and `codex-code-review.yml` trigger ONLY on `pull_request: [labeled]` with labels `claude-review` / `codex-review` (or an `@claude review` comment from a member). Nothing reviews a PR automatically.

**Why:** Opened PR #828 (2026-07-14) without the labels — no bot review ever posted; Evan had to ask why and re-add labels himself.

**How to apply:** When opening any PR in thrive, add both labels immediately (`gh pr edit <n> --add-label claude-review --add-label codex-review`) and verify both workflows dispatched non-skipped runs (`gh run list`) — a single edit adding two labels can deliver only one label event, and each label event also creates a `skipped` run of the *other* workflow (don't misread those). When Evan asks why a review/CI thing isn't working, the deliverable is the diagnosis — report it and stop; he drives the GitHub UI actions himself unless he says otherwise (2026-07-14: I re-labeled and armed watchers when he only wanted the why).

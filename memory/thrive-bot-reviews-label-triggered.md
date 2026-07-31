---
name: thrive-bot-reviews-label-triggered
description: thrive Claude bot review only runs when the claude-review label is added — add it at PR creation and verify the run dispatched; codex-review label is dead (Codex fires on PR open)
metadata: 
  node_type: memory
  type: project
  originSessionId: 6d69cf5a-a9e8-4b88-87db-e40d2cef581a
  modified: 2026-07-31T17:11:46.817Z
---

In Bionic-Health/thrive, `claude-code-review.yml` triggers ONLY on `pull_request: [labeled]` with the `claude-review` label (or an `@claude review` comment from a member). Nothing reviews a PR automatically. **The `codex-review` label is dead (2026-07-31): never add it.** Codex reviews fire on their own when the PR is opened (the human's decision) — drafts get Claude review only, and no one waits for a Codex pass (see [[codex-review-posts-as-github-actions-comment]]).

**Why:** Opened PR #828 (2026-07-14) without the label — no bot review ever posted; Evan had to ask why and re-add labels himself. 2026-07-31: Evan — stop adding `codex-review`; drafts are labeled and reviewed for `claude-review` only.

**How to apply:** When opening any PR in thrive, add `claude-review` immediately (`gh pr edit <n> --add-label claude-review`) and verify the workflow dispatched a non-skipped run (`gh run list`). When Evan asks why a review/CI thing isn't working, the deliverable is the diagnosis — report it and stop; he drives the GitHub UI actions himself unless he says otherwise (2026-07-14: I re-labeled and armed watchers when he only wanted the why).

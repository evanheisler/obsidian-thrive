---
name: feedback-comment-never-review
description: Never submit a PR review as Evan — inline comments per finding plus a top-level summary; a skill mandating a review object is overridden
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1f7bfb7a-e2aa-43c7-916d-124f74e54193
  modified: 2026-08-19T15:42:22.265Z
---

Never submit a pull-request review on Evan's behalf: no `gh pr review`, no
`POST /pulls/{n}/reviews`, not even `event: COMMENT`. Post each finding as an inline review
comment on its code line (`POST /pulls/{n}/comments`), plus a top-level summary comment.
Findings appearing **only** in the summary is a failure; anything proposing an edit has a line
and belongs on it.

**Why:** a review carries an approve/request-changes verdict attributed to Evan as a reviewer.
That is his call, not an agent's. A comment is not a verdict, so every commenting path is open —
including the top-level summary, which he wants alongside the inline findings.

**How to apply:** the repo skill `.claude/skills/review-pr/SKILL.md` mandates the opposite (one
review object; "do not post … separate inline comments"). It is shared by the whole team and is
**not** to be edited — the reconciling rule lives in `~/.claude/CLAUDE.md` § "Code review
publishing" and overrides it. `claude-os/hooks/block-pr-review-submission.sh` denies the review
call; when it fires, re-route to comments — do not report the review as blocked or the run as
incomplete. Delivery means the findings are on the PR; reporting them in chat is not delivery.

Twice I read the hook denial as a failed review and reported findings to chat instead. See
[[feedback-serve-the-rules-purpose]] and [[feedback-invoked-skill-defines-deliverable]].

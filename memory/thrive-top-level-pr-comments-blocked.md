---
name: thrive-top-level-pr-comments-blocked
description: "In BOTH thrive and bionic-health-app, a hook blocks top-level PR/issue comments AND whole review submissions (pulls/N/reviews) — every finding must be its own inline POST to pulls/N/comments; there is no PR-level summary path left"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0329d59a-995f-46d0-9472-854332698a8f
  modified: 2026-08-17T22:27:20.699Z
---

A PreToolUse hook blocks top-level PR/issue **comments** in **both** `thrive` and
`bionic-health-app` (confirmed in bionic-health-app on 2026-07-27, PR #2250) —
`gh pr comment` returns "Top-level PR comments are blocked." Assume it applies to any
Bionic repo, not just thrive.

The block covers `gh pr comment` and `gh api .../issues/N/comments` — even a *read* of
that endpoint matches. The block aborts the **entire** Bash call, so batching a top-level comment
with allowed calls loses all of them — verify what actually posted before re-running.

**2026-07-31 update — `gh pr review --comment` is ALSO blocked now.** On thrive PR #953 it
returned the same "Top-level PR comments are blocked" error, with the hook naming the inline
form as the required replacement. So the escape hatch below is narrower than it was: whether
`gh api .../pulls/N/reviews -X POST -f event=COMMENT` still works is **unverified from the main
session** — subagents reported posting review-COMMENTs successfully in the same session, so the
hook may not apply to them. Do not plan around the review-body path from the main session
without testing it; the inline form always works.

**2026-08-17 update — the review-body path is now blocked from the main session too.**
On bionic-health-app PR #2401, `gh api .../pulls/2401/reviews --method POST` (event=COMMENT,
with a `comments[]` array) was refused with "Submitting a pull-request review is blocked.
Top-level PR comments are blocked," and the hook named the per-comment inline form as the
replacement. **Submitting a whole review is blocked, not just its body** — so the batched
`comments[]` array does not post either; every finding must go as its own
`POST /pulls/N/comments` call. Budget one call per finding.

Formerly-working mechanism, now refused from the main session — do not build a review flow on it:

```
gh api repos/OWNER/REPO/pulls/N/reviews -X POST -f event=COMMENT -F body=@file
```

(It rendered as a top-level review — `#pullrequestreview-...`.) When it is refused, anchor the
PR-wide note inline to the most representative changed line rather than dropping it — a
sign-off or summary that stays in chat instead of landing on the PR is worse than an imperfect
anchor. Pick a line the note is actually about.

Line-specific feedback must be an **inline review comment anchored to a code line**:

```
gh api repos/OWNER/REPO/pulls/N/comments \
  -f commit_id=SHA -f path=PATH -F line=LINE -f side=RIGHT -F body=@file
```

Replies to existing inline threads (`.../pulls/N/comments/{id}/replies`) and
GraphQL `resolveReviewThread` are allowed. To acknowledge a bot's top-level
finding (e.g. Codex, which posts one top-level `## Codex Review` comment — see
[[codex-review-posts-as-github-actions-comment]]), anchor the reply inline to the
exact line the fix changed, then resolve that self-authored thread. Use
`-F body=@file`, not `-f`, for comment bodies ([[feedback-gh-api-body-file]]).

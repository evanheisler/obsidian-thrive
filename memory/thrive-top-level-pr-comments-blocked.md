---
name: thrive-top-level-pr-comments-blocked
description: "In thrive, a hook blocks top-level PR/issue *comments* (gh pr comment) to force feedback inline — but a PR *review* body (pulls/N/reviews event=COMMENT) IS allowed for PR-level summaries"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0329d59a-995f-46d0-9472-854332698a8f
  modified: 2026-07-23T20:33:24.690Z
---

A PreToolUse hook in the thrive repo blocks top-level PR/issue **comments**
(`gh pr comment`, `gh api .../issues/N/comments`) — even a *read* of that endpoint
matches. The block aborts the **entire** Bash call, so batching a top-level comment
with allowed calls loses all of them — verify what actually posted before re-running.

**The block's intent is to route line-level feedback inline, NOT to forbid all
commentary.** A PR-level summary/status comment (e.g. "this POC is superseded") is
allowed as a **PR review body** — this is NOT blocked and is the right mechanism:

```
gh api repos/OWNER/REPO/pulls/N/reviews -X POST -f event=COMMENT -F body=@file
```

(It renders as a top-level review on the PR — `#pullrequestreview-...`.) Do NOT
conclude "any comment is blocked" and fall back to an awkward inline anchor for a
PR-wide note — use a review-COMMENT. Reserve inline for feedback about a specific line.

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

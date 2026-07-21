---
name: thrive-top-level-pr-comments-blocked
description: "In thrive, a hook blocks top-level PR comments — post every reply as an inline review comment anchored to a code line"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0329d59a-995f-46d0-9472-854332698a8f
  modified: 2026-07-21T21:24:19.361Z
---

A PreToolUse hook in the thrive repo blocks top-level PR comments (`gh pr comment`,
`gh api .../issues/N/comments`). The block aborts the **entire** Bash call, so
batching a top-level comment with allowed inline replies loses all of them —
verify what actually posted before re-running.

Everything must be an **inline review comment anchored to a code line**:

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

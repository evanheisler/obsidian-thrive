---
name: feedback-gh-api-body-file
description: "gh api -f body=@file posts the literal string, not the file contents"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9e04ebff-d053-4fba-80a5-e9057402acb4
  modified: 2026-07-21T20:43:28.246Z
---

`gh api ... -f body=@/tmp/x.md` posts the literal text "@/tmp/x.md" to the PR/comment — `-f` sends raw strings and does NOT expand `@file`. Only `-F` expands `@filename` (and `@-` for stdin). For multi-line comment bodies, either pass the text inline (`-f body="line1
line2"`) or use `-F body=@/tmp/x.md`.

**Why:** posted two garbage review replies (`@/tmp/reply_filter.md`) to a thrive PR; Evan caught it. A malformed bot-reply reply is worse than none — it reads as broken automation on a PR a teammate will review.

**How to apply:** after posting any PR comment via `gh api`, verify the body landed (`gh api .../comments --jq '...| .body[0:80]'`) before calling the review loop done. Anchored inline comments need `-f commit_id=SHA -f path=P -F line=N -f side=RIGHT` when top-level PR comments are hook-blocked. Related: [[feedback-refetch-before-asserting-state]].

---
name: codex-review-posts-as-github-actions-comment
description: "Codex bot review lands as a top-level github-actions PR comment, not inline threads or a codex author — check there or you'll miss High findings"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 8261d594-cae5-487e-be61-510d28f53fb2
---

On the Thrive repo (Bionic-Health/thrive), the Codex review bot posts its findings
as a **single top-level issue comment authored by `github-actions`** whose body
starts with `## Codex Review`. It does NOT post inline review threads and there is
no `codex`-authored review. The `claude-review` bot, by contrast, posts a summary
review plus inline review threads (author `claude` / `claude[bot]`).

To fetch Codex findings reliably:
`gh pr view <n> --json comments` → scan for a comment whose body contains
`## Codex Review`. Filtering `--json reviews` by author, or scanning inline review
threads (`/pulls/<n>/comments`), will MISS it entirely.

**Failure this fixes:** a ship-issue executor assumed "codex-review skips this repo"
because it only checked reviews/inline threads, silently dropping an unaddressed
High Codex finding on PR #790 (BH-3222). Never assert a bot "skipped" without
checking the github-actions comment. See [[feedback-refetch-before-asserting-state]].

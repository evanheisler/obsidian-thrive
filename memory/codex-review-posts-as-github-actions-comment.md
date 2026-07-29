---
name: codex-review-posts-as-github-actions-comment
description: "Codex review in thrive is now the Codex Cloud App — it fires on PR open, NOT on drafts, and the codex-review label is inert; the old github-actions comment form is historical"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 8261d594-cae5-487e-be61-510d28f53fb2
  modified: 2026-07-29T15:33:45.979Z
---

**Current (since `475f5db5`, merged 2026-07-29, PR #939).** On Bionic-Health/thrive,
Codex review runs as the **Codex Cloud App**, not a GitHub Action. `codex-code-review.yml`
was deleted; **no workflow references codex at all**. Consequences:

- The **`codex-review` label is inert** — adding it triggers nothing. Stop adding it in
  `ship-issue` / `work-project` dispatches.
- Codex reviews **on PR open** per repo preferences, and **does not fire on draft PRs**.
  Since the loop stops at a draft, **agent-shipped PRs get Claude review only**; Codex
  arrives after the human un-drafts.
- When it does post, the author is **`chatgpt-codex-connector[bot]`**, not `github-actions`.
- It is steered only by a `## Code Review Rules` section in `AGENTS.md`.

Never report "waiting on Codex" for a draft PR — it is not coming. See
[[feedback-refetch-before-asserting-state]] and [[feedback-red-check-is-not-green]].

**Historical (pre-`475f5db5`), still useful for reading old PRs.** The Codex Action posted
a **single top-level issue comment authored by `github-actions`** whose body starts with
`## Codex Review` — no inline threads, no `codex`-authored review. To find findings on an
old PR: `gh pr view <n> --json comments` → scan for `## Codex Review`. Filtering
`--json reviews` by author, or scanning `/pulls/<n>/comments`, misses it. That form caused
a ship-issue executor to conclude "codex skips this repo" and silently drop an unaddressed
High finding on PR #790 (BH-3222).

Also historical: a red `codex-review` **check** with empty output meant the action errored
(2026-07-24: `gpt-5-codex` deprecated repo-wide), not a code finding. That check no longer
exists.

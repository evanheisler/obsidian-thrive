---
name: feedback-repo-edits-need-nwt-worktree
description: "Never edit files directly in a working repo under ~/dev — create a worktree first with the `nwt` alias (~/.zshrc); worktrees live at ~/worktrees/<repo>/<branch>"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: af78ee30-2966-4203-b497-b65686629141
---

Edits that touch a repo under development (e.g. ~/dev/thrive) must happen in a dedicated
worktree, created with the `nwt <branch> [base-ref]` zsh function from ~/.zshrc. Worktrees
land at `~/worktrees/<repo>/<branch>` and `.worktreerc` hooks run setup (pnpm install etc.).
Companions: `rwt` (remove), `cwt` (jump), `rpr`/`rrpr` (PR review worktrees).

**Why:** Evan's main checkouts are live workspaces; direct edits pollute them (2026-07-06 —
I edited thrive skill docs in ~/dev/thrive directly and had to migrate them to a worktree).

**How to apply:** Before the first edit to any repo file, run `zsh -ic 'cd <repo> && nwt
<branch>'` (functions only load in interactive zsh) and make all changes in the worktree.
Vault and ~/.zshrc edits are not repos-under-development and are exempt.

---
name: feedback-worktree-base-must-be-fresh-origin
description: "Always branch worktrees off freshly-fetched origin/<base>, and verify any \"X doesn't exist\" claim against origin HEAD before reporting"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ef8efea5-1e2c-4f40-86fd-db7e645971f7
---

Before creating a worktree off a base branch (feature branch or main), **`git fetch origin <base>` first and branch off `origin/<base>`, never a stale local ref.** A local `theme-v2` (or any base) can be many commits behind origin; `nwt <branch> <base>` off a stale local ref silently pins the worktree to old code.

Concretely this happened: an executor ran `nwt bh-3224 theme-v2` off a local `theme-v2` at `aef3a166`, one commit behind `origin/theme-v2` `0414bece` (#789, the token-generator switch). The stale tree lacked `packages/tokens/tailwind.ts` and the generated `system-*` token wiring, so the executor parked the issue as "tokens not exposed" and I doubled down twice — all read off dead code.

**Why:** A stale base makes present code look absent. A park or "this doesn't exist" conclusion drawn from a stale tree is worse than useless — it publishes false blockers onto the ticket and burns the user's trust.

**How to apply:**
1. In `ship-issue`/`work-project` dispatch, the executor's first action must `git fetch origin <base>` and create the worktree from `origin/<base>` (verify `git rev-parse HEAD` == `git rev-parse origin/<base>` at creation).
2. Before ever reporting that a token/file/symbol "doesn't exist" or parking on its absence, verify against `origin/<base>` HEAD (`git show origin/<base>:<path>`), not just the local worktree.
3. A subagent's park conclusion is a claim to verify, not a fact to relay — spot-check its dispositive premise against origin before passing it to the user.

Related: [[theme-v2-integration-branch]], [[feedback-refetch-before-asserting-state]], [[feedback-correction-is-not-a-go-signal]].

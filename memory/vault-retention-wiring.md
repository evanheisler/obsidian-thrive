---
name: vault-retention-wiring
description: How this machine's memory/vault retention is actually wired — read before claiming memory did or didn't reach the vault
metadata:
  node_type: memory
  type: reference
---

The per-project auto-memory dir **is** the vault, via symlink:
`~/.claude/projects/-Users-evanheisler-dev-thrive/memory` → `/Users/evanheisler/obsidian-thrive/memory`.
So a Write to the auto-memory path lands in the vault. Never say "I wrote auto-memory, not the vault" — they are the same directory. (2026-07-08: I made exactly that false claim and it cost trust.)

Retention has two halves:
- **Mechanical (automatic):** a `SessionEnd` hook (`claude-os` `hooks/os-session-end.sh`) commits `git add -A` + pushes the vault on every session end. This is why writes stop piling up uncommitted. It cannot distill — a hook runs a shell command, not the model.
- **Distillation (manual):** `/session-close` is a skill, NOT a hook. Nothing auto-invokes it. It does the model-driven distill + lint + commit + push.

Before Jul 2026 the mechanical half didn't exist, so every session's memory writes reached the vault dir but were never committed/pushed — from git/remote it looked like "nothing happened." That was the actual breakage, not the memory routing.

Gotcha: `claude-os` `setup.sh` **cannot run from a git worktree** — `skills/*` are relative symlinks (`../../.agents/...`) that only resolve from the canonical `~/claude-os` checkout. Run installs from `~/claude-os`, not a worktree. See [[feedback-repo-edits-need-nwt-worktree]] (the worktree rule has this exception).

---
title: Claude OS on this machine
summary: Local claude-os install facts — repo path, drift check, memory symlink, vault remote
last_updated: 2026-07-06
---

# Claude OS — machine facts

- claude-os repo lives at `~/claude-os`; install drift check: `~/claude-os/setup.sh --check`.
  `log: 2026-07-06`
- Harness auto-memory symlinks into the vault:
  `~/.claude/projects/-Users-evanheisler-obsidian-thrive/memory` → `<vault>/memory`.
  Memories commit and push with the vault, so they sync across machines. `log: 2026-07-06`
- Vault remote: `git@github.com:evanheisler/obsidian-thrive.git`. `log: 2026-07-06`

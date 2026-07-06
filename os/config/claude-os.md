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
- claude-os `skills/` symlinks resolve against the machine-local `~/.agents/skills/` (skills
  CLI), which differs per machine — a dangling link means another machine installed it, not
  that it's abandoned. Curate claude-os links to the OS loop only. `log: 2026-07-06`
- `setup.sh` installs additively (`cp -R`, no prune): a skill removed from the repo must be
  removed from `~/.claude/skills/` manually on each machine. `log: 2026-07-06`
- All Thrive work project dirs share the vault memory: `~/.claude/projects/<slug>/memory` →
  `<vault>/memory` for dev, dev-thrive, dev-bionic-health-app, dev-feature-toggle-service,
  dev-langgraph-assistants (plus the vault itself, which setup.sh owns). New work repos get
  the same symlink manually. Pre-migration memories archived at
  `~/.claude/backups/memory-migration-2026-07-06/`. `log: 2026-07-06`

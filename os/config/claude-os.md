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
- `setup.sh` owns `~/.claude/skills/` outright: it `rm -rf`s the dir and repopulates from the
  claude-os repo on every run (since claude-os `ba9efbc`, 2026-07-04), so deletions and renames
  propagate — and so anything placed there by hand is wiped on the next run. `log: 2026-07-06`
- Vault work skills load user-wide via symlinks:
  `~/.claude/skills/<name>` → `<vault>/.claude/skills/<name>` for the 8 work skills
  (registry: [[skills]]). Project-scoped
  `.claude/skills/` only loads when the session runs inside that project, so vault-homed skills
  are invisible from work repos without this. `setup.sh` owns the step: on every run it
  symlinks each dir under `<vault>/.claude/skills/` into `~/.claude/skills/` (claude-os names
  win on collision), and `--check` flags a missing link as drift. New vault skills publish by
  re-running `setup.sh`. `log: 2026-07-06 — vault-skill symlinks`
- All Thrive work project dirs share the vault memory: `~/.claude/projects/<slug>/memory` →
  `<vault>/memory` for dev, dev-thrive, dev-bionic-health-app, dev-feature-toggle-service,
  dev-langgraph-assistants (plus the vault itself, which setup.sh owns). New work repos get
  the same symlink manually. Pre-migration memories archived at
  `~/.claude/backups/memory-migration-2026-07-06/`. `log: 2026-07-06`

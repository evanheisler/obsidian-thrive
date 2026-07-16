---
title: Claude OS on this machine
summary: Local claude-os install facts — repo path, drift check, memory symlink, vault remote, permission rules
last_updated: 2026-07-16
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
- `settings.json` is **partially** claude-os-managed, and the split matters: `hooks` merges by
  script name (other keys preserved), `permissions` is overwritten wholesale from
  `global/settings-permissions.json`, and everything else (`enabledPlugins`, `effortLevel`,
  `tui`, model/theme) is machine-local and untouched. An "always allow → user settings" choice
  is therefore reverted on the next `setup.sh` run — re-add it to the repo fragment instead.
  `--check` flags a permissions mismatch as drift. `log: 2026-07-15`
- Claude Code **2.1.210** (2026-07-14) changed permission-rule matching: only `Edit(path)` and
  `Read(path)` rules match file tools. `Write(path)`, `MultiEdit(path)`, `NotebookEdit(path)`
  → use `Edit(path)`; `Glob(path)` → use `Read(path)`. Rules in the dead form warn at startup
  and match nothing — which silently voided the `.env`/`production.*`/`secrets/**` deny list
  until 2026-07-15. Only rules *with* a path pattern are affected; bare `Edit` / `MultiEdit`
  entries are fine. `log: 2026-07-15`
- The harness safety classifier **blocks the agent from writing
  `global/settings-permissions.json`** — an agent editing its own allowlist reads as
  self-modification regardless of whether the rules are new. Evan must place that file by hand
  (`cp` from a draft); routing around the block with Bash would defeat it. The rest of the
  change (`setup.sh`, README, install, commit) is unblocked. `log: 2026-07-15`
- **`rm -rf` is denied**, including on gitignored build output. Use `git clean -xfd <path>`
  (dry-run `-xfdn` first) to drop artifacts inside a repo. Compound commands are denied as a
  unit — a single denied clause blocks the whole invocation, so keep destructive steps in their
  own call rather than chaining them behind `&&`. `log: 2026-07-16`
- All Thrive work project dirs share the vault memory: `~/.claude/projects/<slug>/memory` →
  `<vault>/memory` for dev, dev-thrive, dev-bionic-health-app, dev-feature-toggle-service,
  dev-langgraph-assistants (plus the vault itself, which setup.sh owns). New work repos get
  the same symlink manually. Pre-migration memories archived at
  `~/.claude/backups/memory-migration-2026-07-06/`. `log: 2026-07-06`

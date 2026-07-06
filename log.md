# Session log

Append-only. Newest entry at the bottom. Schema in `CLAUDE.md`.

## 2026-07-06 — First-startup verification of claude-os + vault
repo: this vault

- Verified the full loop on first startup: boot hook context, skill invocation (`/lint`,
  `/session-close`), memory recording (writes via the harness path land in `memory/` through
  the symlink; `MEMORY.md` index created), skill writing (canary `/vault-smoke-test` in
  `.claude/skills/`, registered in `os/skills.md` — delete after next-session verification),
  vault commit + push.
- Lint findings fixed: `.obsidian/app.json` `userIgnoreFilters` set (`log.md`, `memory/`);
  placeholder `last_updated` dates filled in `index.md`, `os/skills.md`,
  `os/workflows/session-close.md`. Install drift check clean; initial scaffolding committed
  (reconciles the boot warning — no prior session existed).
- Wiki/os pages touched: `os/skills.md`, `os/config/claude-os.md`, `index.md`,
  `os/workflows/session-close.md`
- Learnings: machine facts distilled to `os/config/claude-os.md` (claude-os repo path,
  drift-check command, memory-symlink design, vault remote); skill-authoring rule added to
  `os/skills.md` (new vault skills go through superpowers:writing-skills TDD).

## 2026-07-06 — Machine migration: skills, memory, loose config; fresh-start decision
repo: this vault + claude-os + ~/.claude machine state

- Smoke test passed: `/vault-smoke-test` invoked from the vault's `.claude/skills/` —
  skill pipeline verified end-to-end. Canary retained (deletion denied at prompt).
- Skills migrated per coupling rule (adopted from the personal vault after Evan pointed me at
  its history — I first re-recommended vendoring, the exact recorded mistake): 8 work skills
  moved from unversioned `~/.agents/skills/` into this vault's `.claude/skills/` and
  registered (`plan-project`, `work-project`, `ship-issue`, `orchestrating-linear-work`,
  `weekly-review`, `project-status-update`, `monitor-code-review-requests`,
  `approval-gated-code-review`); `pr-comment-responder` deleted (never used); 28 stale
  skill-lock entries pruned (now plugin-delivered); 6 dangling claude-os skill links dropped
  (other-machine installs, not OS-loop). Correction: absence of config strings ≠ generic —
  work-serving and meta-skills are vault-scoped.
- Legacy memory: fresh-start decision — 202 feedback files triaged (39 dup / 7 dead /
  148 live), then Evan cancelled promotion: archived data stays archived
  (`~/.claude/backups/memory-migration-2026-07-06/`), nothing spreads into OS or vault.
  All five work project dirs' memory now symlinks to `<vault>/memory` (one shared corpus
  going forward).
- Loose `~/.claude` files adopted into claude-os (statusline.py, core-rules.md, 4 hooks —
  all now setup.sh-managed with drift checks). Two corrections en route: I briefly broke
  three live hooks moving their dir (restored same turn), and I put a grafana setup step in
  claude-os machine-setup — reverted; work content never goes in OS docs.
- Grafana MCP: verified end-to-end (both instances, tokens valid), but I mis-registered it
  user-scope — reverted. It stays opt-in via `claude --mcp-config ~/.claude/mcp-grafana.json`
  by design (docker container must not start every session). Documented in
  `os/config/mcp-servers.md`.
- Wiki/os pages touched: `os/skills.md`, `os/config/claude-os.md`, `os/config/mcp-servers.md`
  (new), `index.md`
- Learnings: placement-by-coupling extended to ALL claude-os content (memory:
  `feedback-skill-placement-by-coupling`); existing wiring or its absence is the design —
  verify, don't re-architect (memory: `feedback-dont-repave-deliberate-wiring`, and
  `os/config/mcp-servers.md`); fresh start means fresh — no bulk migration of archived data
  (memory: `feedback-fresh-start-means-fresh`); machine facts in `os/config/claude-os.md`
  (memory symlinks, setup.sh no-prune, dangling-link semantics).

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
- Post-close housekeeping: `/vault-smoke-test` canary + registry row removed (pipeline
  verified); `.obsidian/graph.json` gitignored + untracked — it churns on every graph-UI
  adjustment.
- Learnings: placement-by-coupling extended to ALL claude-os content (memory:
  `feedback-skill-placement-by-coupling`); existing wiring or its absence is the design —
  verify, don't re-architect (memory: `feedback-dont-repave-deliberate-wiring`, and
  `os/config/mcp-servers.md`); fresh start means fresh — no bulk migration of archived data
  (memory: `feedback-fresh-start-means-fresh`); machine facts in `os/config/claude-os.md`
  (memory symlinks, setup.sh no-prune, dangling-link semantics).

## 2026-07-06 — Wiki bootstrap: thrive codebase mapped into six pages
repo: ~/dev/thrive (read-only survey) + this vault

- First wiki content in this vault. Four parallel explore agents mapped apps/ehr,
  apps/patient, packages/, and CI/CD; distilled with direct reads of docs/agents/,
  docs/medplum-documents.md, and package manifests.
- Pages created: `wiki/thrive-repo-map.md`, `wiki/thrive-ehr-architecture.md`,
  `wiki/thrive-patient-architecture.md`, `wiki/thrive-deployments.md`,
  `wiki/thrive-medplum-fhir.md`, `wiki/thrive-telemetry-phi.md`; `index.md` updated.
- Load-bearing facts captured: packages ship raw TS (no build step) with pnpm-catalog
  version pinning; Medplum only reachable through the Bionic API (no Medplum-native auth);
  EHR ships via ArgoCD GitOps (dev auto on merge, prod = GitHub Release) while patient
  ships via EAS fingerprint builds + nightly OTA (prod OTA = manual staging republish);
  PostHog is the sole telemetry/error stack under BAA with policy centralized in
  `@repo/utils/posthog`; patient auth is mid-migration Rownd→SuperTokens behind `useAuth()`.
- Repo self-documents well (AGENTS.md tree, docs/runbooks, docs/plans, docs/agents);
  wiki pages point there rather than duplicate. `CONTEXT-MAP.md`/`docs/adr/` referenced
  by docs/agents/domain.md but intentionally absent (lazy creation via /domain-modeling).

## 2026-07-06 — Grafana MCP migration to new instances; claude-os guard fix; worktree correction
repo: this vault + claude-os + Bionic-Health/thrive (PR #771)

- Grafana MCP moved to the new instances (grafana-new.bionichealth.com / .dev), verified
  end-to-end on both (initialize + list_datasources + Loki queries). Config relocated from
  `~/.claude/` into this vault's `.claude/mcp-grafana.json` after correction: the MCP is
  machine/context wiring, not claude-os. Tokens moved out of the config into 1Password
  (`op://Agents/Grafana/prod-token|dev-token`, resolved via `op run` at spawn). Session
  invocation restored as the `claude-grafana` zsh alias.
- Root cause of two agents wrongly routing through claude-os: the claude-dir-guard hook
  claimed every `~/.claude` path was claude-os-installed. Fixed in claude-os (`bb9e2e9`):
  managed paths keep the drift message; unmanaged paths are pointed at the vault's `.claude/`.
- thrive `grafana-log-debugging` skill rewritten against the live new instance (UID
  `loki-new`, `app` label → `service_name`, quirks re-verified) — draft PR
  Bionic-Health/thrive#771, built in a `nwt` worktree after correction: repo edits never go
  directly into `~/dev` checkouts.
- Wiki/os pages touched: [[mcp-servers]] (`os/config/mcp-servers.md`)
- Learnings: instance migration invalidates Grafana service-account tokens and changed the
  Loki label schema (`os/config/mcp-servers.md`); claude-os owns only the OS loop — MCP/work
  config is vault-scoped (auto-memory `feedback-claude-os-owns-nothing-work-related`); repo
  edits require `nwt` worktrees (auto-memory `feedback-repo-edits-need-nwt-worktree`).

## 2026-07-06 — Post-close correction: shared docs stay machine-agnostic
repo: Bionic-Health/thrive (PR #771)

- PR #771's setup.md had been rewritten around this machine's wiring (vault config,
  `claude-grafana` alias, 1Password) — teammates have none of it. Restored a team-generic
  setup doc (own token, local standalone config, per-session opt-in); PR body updated.
- Learnings: shared-repo docs must work on a teammate's fresh laptop — personal wiring stays
  in the vault (auto-memory `feedback-shared-docs-stay-machine-agnostic`).

## 2026-07-06 — Vault skills published user-wide; graph linking conventions
repo: this vault + evanheisler/claude-os

- Morning migration broke the 8 work skills: homing them in `<vault>/.claude/skills/` made
  them invisible outside the vault — project-scoped skills only load when the session runs
  inside that project. Fixed durably in claude-os `setup.sh` (`4fe3368`): every install
  symlinks `<vault>/.claude/skills/*` into `~/.claude/skills/` (claude-os names win on
  collision) and `--check` flags a missing link as drift. Verified: full install republishes
  all 8, `--check` clean. Neither vault ever had this wiring — old machine worked by accident.
- Corrected a stale claim in [[claude-os]]: `setup.sh` wipes-and-replaces `~/.claude/skills/`
  (since claude-os `ba9efbc`, 2026-07-04), not additive — hand-placed files there don't survive.
- Graph hygiene (Evan flagged loose nodes): [[index]] entries converted to wikilinks — the
  inline-code citation rule covers only `log:`/`source:` citations, not page references;
  `README.md` + `CLAUDE.md` added to `userIgnoreFilters`; cross-links added from os/ pages.
  Kernel (CLAUDE.md) amended with both conventions.
- Committed two memories from an unclosed prior session (pr-descriptions-short,
  no-abbreviated-decision-prompts) — content self-contained, that session's log entry is lost.
- Wiki/os pages touched: [[index]], [[skills]], [[claude-os]], [[mcp-servers]], [[session-close]]
- Learnings: skill placement scope ≠ availability scope — vault-homed skills need user-wide
  publishing, now owned by `setup.sh` ([[claude-os]], [[skills]], auto-memory
  `feedback-skill-placement-by-coupling`); index/page references are wikilinks, citations are
  not, plumbing files stay out of the graph (kernel CLAUDE.md).

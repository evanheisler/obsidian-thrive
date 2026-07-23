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

## 2026-07-08 — Release traceability: releases-as-deploy-artifacts (Linear project)
repo: Bionic-Health/thrive (Linear) + this vault

- Task: research Thrive's manual multi-surface release setup (EHR prod, patient web
  prod, native store builds, OTA staging/prod) and fix "drift" — which Evan defined as
  *no durable record of what commit shipped to each surface*, NOT cross-surface divergence.
- Model landed: **a GitHub Release per surface IS that surface's prod-deploy artifact and
  its record.** Publishing a surface's Release is the deploy; the tag prefix ties a Release
  to one surface; the Releases page becomes the deploy ledger (latest per surface = live,
  notes = what changed). Surfaces stay independent — no forced commit parity. EHR already
  works this way; project generalizes it and retires the manual `workflow_dispatch` triggers.
  Tags: `ehr/prod/vX.Y.Z`, `app/vX.Y.0`, `ota/prod/...`, `ota/staging/...` (pre-release),
  `web/prod/vX.Y.Z` (all tenants) / `web/prod/<tenant>/vX.Y.Z`.
- Delivered: Linear project *Releases as deploy artifacts* (BH, slug
  `releases-as-deploy-artifacts-9c9d8ed13432`), PRD in the project overview, 4 ready-for-agent
  issues — BH-3217 (EHR Release-trigger gate; must land first, blocks the rest), BH-3218
  (web tenant-aware), BH-3219 (native build+submit), BH-3220 (OTA staging+prod). Blocked-by
  links wired 3218/3219/3220 → 3217.
- Wiki/os pages touched: [[thrive-deployments]] (added "Planned — releases as deploy artifacts").
- Learnings: two corrections, both cost most of a painful, circular session. (1) A cited
  reference repo (bionic-health-app's tag strategy) is a parts bin, not a blueprint — I
  imported its whole "one version drives every channel / forced parity" model when Evan's goal
  was narrow traceability (auto-memory `feedback-extract-mechanism-not-whole-model`). (2) Once
  Evan named the model ("a Release is the artifact, tied to a surface") I kept re-abstracting
  it and reopened already-settled decisions (tenant deploys, ready-for-agent) — echo his exact
  terms and hold decided points (auto-memory `feedback-mirror-users-model-verbatim`).

## 2026-07-10 — PR #794 modern-header titles: review-feedback pass
repo: Bionic-Health/thrive (worktree bh-3221-modern-header-titles)

- Handled the two open inline threads on PR #794 (both leonelgalan, AI-assisted 🤖) via
  approval-gated-code-review. Verified each claim against the code before acting.
- Thread 1 (test-coverage): dropping `headerTitle: ''` from `buildSubRouteScreenOptions`
  moved sub-route titling entirely onto each `Stack.Screen` `title`; an omitted title would
  silently render the raw route name (`[code]`). Builder tests asserted the blank was gone but
  nothing locked a real sub-route title — a gap vs BH-3221 acceptance. Added co-located layout
  render tests for both biomarker layouts (home + my-health) asserting `[code]` resolves to its
  "Biomarker" copy token. Used the repo's `getByTestIdOfType` helper (RNTL `getByTestId` doesn't
  resolve under patient's react-native-web + jsdom setup).
- Thread 2 (naming, marked Optional): renamed the branded slot pair to match the profile pair —
  `brandedHeaderSlotOptions`→`brandedHeaderItemOptions`, `brandedHeaderSlots`→`brandedHeaderLeftOptions`
  (`Item` = iOS items API, `Left` = `headerLeft`).
- Commits: 5932aebc (fixes) → 265835ed (CI lint fixup: named the `Stack.Screen` mock to satisfy
  react/display-name). Both replies posted, both threads resolved. PR already APPROVED.
- Wiki/os pages touched: none.
- Learnings: one correction. I stopped for approval on a mechanical CI lint fix to my own
  already-approved change — Evan: "this is a syntax change why do I need to approve it." The
  approval gate covers publication of review responses (the response commit + GitHub replies),
  not follow-up CI fixups on an approved diff. Captured as auto-memory
  `feedback-gate-covers-publication-not-ci-fixups`.

## 2026-07-13 — Home Revamp Groundwork: plan-project + work-project end-to-end
repo: Bionic-Health/thrive (+ Linear project "Home Revamp Groundwork")

- Planned (2026-07-10) and executed the full groundwork project: PRD in the Linear project,
  9 issues shipped via parallel executors. Merged: #815 task-detail container, #816 home
  decomposition, #817 convention docs/skill/glossary, #819 Task naming, #820 revamp toggle,
  #821 task container splits. Open at close: #818 home hygiene (rebased 3×, mergeable),
  #822 Button↔Figma alignment (BH-3264, reworked through review). FTS #194 left open, unneeded.
- Stack maintenance ran as designed: recorded fork points + `git rebase --onto main <tip>`
  after each squash-merge; conflicts were mechanical import-move collisions, resolved by
  composing main's content with the branch's path renames.
- Toggle model corrected in review (my spec error, not the executor's): access-control gates
  development (hidden rule + dev-overrides opt-in, ModernHeader pattern); feature-toggle-service
  gates release only, later. BH-3251 spec + PR #820 reworked; wiki updated.
- Wiki/os pages touched: [[thrive-patient-architecture]] (feature-gating model, brandThemeColors
  module-load pitfall, no-executor-dev-servers).
- Learnings: five corrections, all captured as auto-memories at the moment they landed:
  (1) toggle model above (`home-revamp-toggle-user-opt-in` rewritten); (2) copy names the
  feature, never implementation state or toggle mechanics (`feedback-copy-names-feature-not-plumbing`);
  (3) locate the exact artifact a correction references before interpreting — I minted a false
  "never min-height" rule from a comment critique, and twice mis-scoped what "nothing renders"
  meant (`feedback-locate-the-referent-first`); (4) executors never run dev servers — ports
  collide with Evan's session (appended to `feedback-mock-must-show-chrome-relationships`);
  (5) no agent-process narration in PR bodies (same file). Also: no provenance/justification
  comments in code — the 44px and scrim comments were both stripped on review.

## 2026-07-14 — BH-3269 muted→subtle text-token sweep (plan → ship → review)
repo: Bionic-Health/thrive

- Planned + wrote BH-3269 (Configurable Theme mode project): audit patient app's over-use of
  `foreground-muted` for secondary text, swap to `foreground-subtle` (design-system: muted =
  disabled/placeholder/AA-Large-only; subtle = secondary text/AA). Shipped via ship-issue in a
  worktree → PR #829: 125-file sweep (className + style-object text sites), Eyebrow +
  ProductCard.Tag tone API renamed muted→subtle, tests/JSDocs updated. Preflight green.
- Two approval-gated review rounds. Bots (Claude/Codex) + humans (jellis18, leonelgalan).
  Fixes: stale Eyebrow/story labels, notProvided→subtle, decorative badge glyph reverted to
  muted to match its ring, wearables Dismiss icon→subtle to match its label, segmented-control
  test rename + added text-class assertion, two stale JSDocs.
- leonelgalan flagged the ~13 style-object `brandThemeColors[...]` sites don't track live theme
  (pinned dark at module load) — already documented in [[thrive-patient-architecture]] line 51
  (`log: 2026-07-13`). Deferred to BH-2370 with the full site list posted to that issue; no user
  impact today (toggle hidden, default dark).
- Wiki/os pages touched: none (brandThemeColors gotcha already captured; site list delivered to
  BH-2370, not the wiki).
- Learnings: ONE, and it's a THIRD-time repeat — asserted "PR is still a draft / your move is
  un-draft + merge" twice on PR #829 from stale session memory; Evan had un-drafted it and was
  furious (this exact failure also hit #823 same day). Strengthened
  `feedback-refetch-before-asserting-state` with a hard rule: never write a PR lifecycle word
  (draft/ready/open/closed/merged) unless `gh pr view` was run THIS turn; if not fetched, omit
  the status — banned specifically in end-of-turn "your move" signoffs, where all three failures
  occurred.

### Correction (same day, post-close) — BH-3269 style-object deferral was wrong
- The "deferred to BH-2370, no user impact" bullet above is FALSE. BH-2370 (dev toggle) and
  BH-2378 (dynamic theme) both landed ~18 days ago; `resolveBrandThemeColors(mode)`/`useThemeMode`
  already exist. So the light-mode contrast regression at the ~12 style-object `brandThemeColors`
  text sites is live in dev, not blocked. I misread the Linear list's last-updated column
  ("Done 7 min ago" — bumped by my own comment) as a completion date.
- Corrected: filed **BH-3278** (per-site plan; flags that inline styles are sometimes
  load-bearing where classNames don't carry through — markdown especially — so it needs careful
  per-site handling + visual checks in both modes, not a blanket className swap); posted a
  correction on PR #829; repointed the misplaced BH-2370 comment to BH-3278.
- Learning: 4th fact-assertion failure this session — extended `feedback-refetch-before-asserting-state`
  to cover misreading any state/timestamp field (Linear updated-at, CI conclusion), not just PR
  lifecycle. Never infer "just completed / not blocked" from a list column.

## 2026-07-14 — PR #721 review→merge; built reporting-errors skill after mis-analyzing telemetry
repo: Bionic-Health/thrive

- **#721 (appointment confirmation + gated add-to-calendar):** addressed 10 Codex findings —
  fixed 8 (storybook `MockAccessControlProvider` crash fix, dropped ICS `METHOD:PUBLISH`, RFC 5545
  line-folding + trailing CRLF, blob-body test assertion, native alert `(title, body)`, tightened
  brittle `not.toContain('with')`); won't-fix 2 with grounds. Plus a native/web `captureError`
  failure-capture commit. Posted replies, resolved 10 threads. **Merged** (`81125d10`).
- **Big miss → correction → durable fix.** Reviewing the swallowed `catch {}`, I asserted PostHog
  is funnel-only / empty-catch is house style / telemetry is out-of-scope — all false, generalized
  from the scheduling funnel file. Evan corrected repeatedly ("read the fucking code, draw your own
  conclusions"). Whole-repo research: `apps/patient/utils/error-tracking.ts` = `captureError`
  (→`$exception`, Error Tracking) + `captureCustomError` (→`custom_error`, Insights), ~30 sites,
  ~50/50 user vs system-triggered; only `console.error` is autocaptured (not warn/log/info — the
  docstring lied).
- **Shipped `reporting-errors` patient skill (PR #834)** via superpowers:writing-skills TDD — after
  Evan flagged my first RED baseline was rigged (prompts that instruct correctness rather than tempt
  the failure). Neutral feature-authoring reproduces the swallow (copies the `account-edit-form`
  straggler); skill flips it to a proper `captureError`. Also fixed the console.warn doc-drift +
  cross-ref from `component-organization`.
- Also this session: filed BH-3279 (`_layout.test.tsx` corrupts typed-route generation) + BH-3275
  (release add-to-calendar / remove flag).
- Wiki/os pages touched: [[thrive-telemetry-phi]]
- Learnings: (1) grep the WHOLE repo before asserting a convention — never generalize from the
  feature path in front of you (`feedback-patterns-mean-whole-codebase`). (2) A shipped +
  un-enforced + inconsistently-taught failure needs in-repo guidance (skill/lint), not a personal
  memory; and a RED/baseline test must *tempt the failure*, not instruct correctness
  (`feedback-systemic-failure-needs-repo-guidance`). (3) Access-control toggle add/remove is
  agent work, not ready-for-human; standalone bug → current cycle, no project
  (`feedback-access-control-is-agent-work`, `feedback-dont-guess-issue-project`).

## 2026-07-15 — Claude Code 2.1.210 voided the Write() permission rules; claude-os now owns permissions
repo: evanheisler/claude-os

- **Startup warnings diagnosed.** Claude Code auto-updated 2.1.209 → 2.1.210 (2026-07-14 17:09
  local); 2.1.210 stopped matching `Write(path)` rules, so the 7 `Write(...)` rules in
  `~/.claude/settings.json` warned on every startup. Confirmed against the binaries, not memory:
  the warning string exists in 2.1.210 and not 2.1.209, and the validator maps
  Write/MultiEdit/NotebookEdit → `Edit`, Glob → `Read`, only for rules carrying a path pattern.
- **The warnings were cosmetic; the state they pointed at was not.** The 4 deny rules
  (`.env`, `.env.*`, `production.*`, `secrets/**`) had gone inert, while `allow` had bare `Edit`
  and no bare `Write` — so under the new semantics file creation had silently become
  unrestricted, including over the paths those denies were meant to protect.
- **Fix (claude-os `303a2e3`, pushed):** new `global/settings-permissions.json` (same list,
  4 denies renamed to `Edit(...)`, 3 dead `Write(...)` allows dropped); `setup.sh` overwrites
  the `permissions` key wholesale + `--check` drift check; README rows. Verified: no drift,
  no `Write(` left installed, headless startup emits no warnings.
- **Ownership question resolved by Evan:** settings.json was half-managed — the guard listed it
  in `MANAGED_TOPLEVEL` and told agents "fix it in claude-os", but only `hooks` was actually in
  the repo. Evan: "claude-os is meant to be the source of truth for configuration across
  machines." Now true for `permissions` too.
- Wiki/os pages touched: [[claude-os]]
- Learnings: (1) The safety classifier blocks me from writing my own permission fragment —
  Evan places that one file by hand; don't route around it with `cp`
  (`os/config/claude-os.md`). (2) Second hit of the same communication failure, so I widened
  the existing memory rather than duplicating it: "gibberish" — I explained the warning in
  permission-rule semantics and binary-grep evidence instead of leading with "your .env deny
  rules stopped working." Expertise is per-domain; harness/config plumbing is my domain, not
  his (`feedback-no-abbreviated-decision-prompts`).

## 2026-07-16 — PR #838 review pass: Display/Eyebrow fold gains a <Heading> primitive
repo: Bionic-Health/thrive (worktree bh-3273-fold-display-eyebrow)

- **Review disposition (BH-3273 / PR #838).** jellis18 raised the load-bearing one: the fold
  traded a 22-use `Display` for 22 hand-copied `accessibilityRole="header"` + `aria-level`
  blocks. His AGENTS.md read was right — the "never extract a single-use component" rule
  licenses inlining one-off wrappers, not deleting a 22-use one — and the body never weighed
  the third option: drop the *styling* wrapper, keep a *semantics* one. Evan chose it.
- **`components/ui/heading.tsx` (`ad1d6228`).** Semantics-only, delegates all type to
  `<Text variant>`. `Omit`s `variant`/`aria-level`/`accessibilityRole` and spreads `rest`
  **first**, so a call site can neither drop nor override the contract; both properties
  mutation-tested (drop the role → 3 fails; spread `rest` last → override test fails). After
  migration `aria-level` appears in exactly one file app-wide; the `ThemedText` alias collapsed
  20 files → 3; net −115 lines.
- **Evan overruled my `level` 1–2 cap.** I'd scoped to what `Display` supported and called
  1–4 YAGNI. Wrong twice: the axis already exists (`Text` ships `h1`–`h4`), and a partial
  primitive invites the bypass — an h3 heading with no `Heading` to reach for gets hand-rolled
  as `<Text variant="h3" accessibilityRole="header" aria-level={3}>`, the exact hazard the
  component exists to remove. Bound is what the scale renders, not the legacy surface.
- **BH-3318 filed**, superseding canceled BH-3272 (whose premise — every spot takes
  `<Text variant>` — was simply false for style-object sinks). Adds `theme/brand-type-styles.ts`
  `typeStyle(slot)` as the third axis bridge, then splits the 139 spots by surface.
- Wiki/os pages touched: [[thrive-patient-architecture]], [[thrive-repo-map]], [[claude-os]]
- Learnings: (1) **The correction of the session** — I twice asserted the style-object sinks
  "need a mechanism that doesn't exist yet" and scoped two tickets around the gap, without
  grepping. Evan: "there are plenty of utilities that already handle the className gap and this
  keeps getting rehashed without any real investigation work or suggested solutions." The repo
  already solved it twice (`brand-theme-colors.ts`, `brand-font-names.ts` — whose docstring
  literally says "Mirrors brand-theme-colors.ts — same pattern, different token type"). A
  capability gap is an empirical claim; the bridges are axis-parallel, so one axis having one
  makes the others' a template, not an open question. Captured mid-session as
  `feedback-no-unverified-capability-gaps`. (2) Also told to stop the prose — "Be clear and
  succinct on what you are asking. Stop with the fucking prose." A decision prompt is the ask
  plus a recommendation, not a briefing; this is
  `feedback-no-abbreviated-decision-prompts`' inverse failure and the same root: burying the
  question. (3) A mutation test that never applied is worse than none — my first run "passed"
  under a stale shell cwd, so the file was never mutated; verify the mutation landed
  (`grep` the mutated line) before trusting the result.

## 2026-07-16 — ship-issue/work-project executor gaps: worktree hydration + reserved app runs

- Evan reported two recurring executor failures via `superpowers:writing-skills`: (1) executors
  `nwt` + `pnpm install` but never `pnpm setup:all`, then thrash on the broken env; (2) when
  they boot the app they invent magic-link emails that can't exist.
- **`ship-issue` SKILL.md**: hydration is now part of worktree creation — `cd "$WT" && pnpm
  install && pnpm setup:all` required before any build/lint/test (thrive; bionic-health-app is
  npm-only, verified against both package.jsons). New step-3 rule: **running the app is
  debugging-only** — Evan spot-checks every edit after it lands; an agent visual check never
  substitutes. Debugging sign-in = `evan.heisler+202602@bionichealth.com` via
  `apps/patient/scripts/magic-link.sh`. Red flags updated to match.
- **`work-project` executor-prompt.md**: same two rules added to the hard-rules block.
- GREEN-verified per writing-skills: three fresh-context subagents against tempting scenarios —
  all three retrieved the hydration sequence, declined the pre-PR visual boot, and named the
  real account. RED baseline = Evan's production observation.
- Memory updated: `feedback-mock-must-show-chrome-relationships` hardened (app runs reserved,
  bot visual check never sufficient) — its old "executors verify visually before pushing" claim
  was stale since the 07-13 no-metro constraint.

## 2026-07-20 — BH-3182 MWL intake HubSpot tracking: bot-review rounds + cross-repo merges

repo: Bionic-Health/bionic-health-app (#2211, merged) + Bionic-Health/thrive (#867, open)

- Shipped both halves of the BH-3182 intake-telemetry reconfiguration through multiple bot-review
  rounds via `/approval-gated-code-review`. #2211 (relay + server-side HubSpot lead forms) merged;
  #867 (client emission) green, conflict-free, waiting on teammate review approval. Resolved two
  successive merge-with-main conflicts on #867 (`loading-results.container.tsx`) — second one was
  main's new `resolveBrandThemeColors(useThemeMode())` theme API colliding with our lead-capture
  effect; kept both.
- Backend review fixes (leonelgalan/jellis18): `stage` Literal→`str|None` (unknown value falls
  back to a neutral legacy config, no milestone stamped — don't 422 the lead away); strict `dob`
  parsing (pydantic v1 `date` coerces numeric strings via epoch fallback — guard with
  `date.fromisoformat` behind a 10-char check); `\Z` not `$` for slug gates (Python `$` allows a
  trailing newline); scoped missing-field warnings off a per-config set; explicit `{token:value}`
  map instead of `getattr` (CLAUDE.md discourages getattr, and it returns `Any`).
- Client review fixes: submit-dedup redesign (persist marker only on non-retryable outcome +
  in-flight ref, moved out of `MwlAnswers` into typed engine state); funnel dedup keys
  (`captureOnce` per product; fold `price_lookup_key` into the `checkout_started` key); removed
  dead `flow_variant`; updated `protocol.md`.
- Wiki/os pages touched: [[thrive-telemetry-phi]] (new intake→HubSpot pipeline section).
- Learnings: (1) **Verify PR/CI/merge state before every status report** — twice asserted stale
  state (said #2211 "will merge shortly" after it had merged; reported #867 green without
  re-checking after main moved and re-conflicted). Evan: "ACTUAL STATUS BEFORE REPORTING or don't
  say anything at all." Reinforces `feedback-refetch-before-asserting-state`. (2) **Sign-off items
  must be reversible decisions I made, stated bug-vs-expected against the ticket** — a list mixing
  one real decision (SetupIntent id in `stripe_session_id`) with expected-behavior notes and
  speculative follow-ups drew "why does this matter / issue or assumption?". Hardened
  `feedback-signoff-bar-real-risk-only`. (3) **HubSpot intake PHI is owning-team-approved** — stop
  treating the in-code forbidden-props guards as policy; reply-no-change + resolve when reviewers
  re-raise it. Hardened `hubspot-baa-intake-telemetry-stance`. (4) **Resolve threads I addressed**
  overrides the ship-issue/approval-gated skills' "never resolve" line; hardened
  `feedback-resolve-addressed-threads`.

## 2026-07-23 — BH-3499 light-mode feedback: dark-on-brand sweep + native theme-layer sync
repo: Bionic-Health/thrive (PR #913, draft)

- Ran /ship-issue BH-3499 (light-mode punchlist). Started scoped to the 3 listed items
  (profile initials, Documents sort toggle, glassmorphic-dark-until-scroll) — Evan twice
  re-scoped upward: (1) item 1's "Evan to investigate" aside did NOT assign it to him — research
  and fix it; (2) the issue is a whole bug *class* (dark `foreground-default` text/glyph on a
  `brand-default` green surface), not those 3 examples — fix every clear instance app-wide.
- **Fixes shipped (4 commits):** items 2/3 → `foreground-inverted`; native iOS glass chrome via
  `Appearance.setColorScheme(mode)` in `LiveThemeProvider` (stage-1 review caught my tab-bar edit
  was dead Expo-template code — dropped it; NativeTabs already syncs via
  `experimental_userInterfaceStyle`); class sweep of 14 sites (chat AI-assistant + Care Team
  native/web own-messages, `CustomAvatar`, send button, camera badge, More/announcement/document
  buttons, web video buttons) — nuanced ones scoped so *received* messages (Stream `myMessageTheme`)
  and shared video CSS vars aren't regressed; header-slot white→dark mount flash via
  `NavigationThemeSync` (react-navigation `ThemeProvider` synced to mode — Expo Router's default
  light theme was creating headers light).
- Rebased #913 onto fresh main mid-work (clean, no re-fire of bots). Header-flash fix is
  **diagnosis-driven, awaiting Evan's iOS spot-check** (can't repro native timing headless).
- Wiki/os pages touched: [[thrive-patient-architecture]] (corrected stale "dark-mode-only" →
  live theme mode; added the three-theme-layer sync rule + `foreground-inverted`-on-brand-default
  convention + Stream own-message theming).
- Learnings: **Enumerated issue items / parenthetical "X to investigate" asides don't bound
  scope — the underlying goal or bug-class does.** Descoping a named/clear item is the mirror of
  inventing scope; both mis-set the deliverable. Captured as auto-memory
  `feedback-anecdotal-notes-dont-descope` (re-fires at scope-read time); it reverses my earlier
  over-application of `feedback-proposals-cover-named-surface-only` (that guards unnamed *adjacent*
  elements, not named/class instances). Read which kind of issue it is first.

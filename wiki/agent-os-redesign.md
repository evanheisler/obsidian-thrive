---
title: Agent OS Redesign
summary: Approved design for claude-os → agent-os + merged vault — decisions, mechanisms, migration plan (grilled and confirmed 2026-08-19)
type: synthesis
last_updated: 2026-08-19
---

# Agent OS redesign

Design settled in a grilled session `log: 2026-08-19`. Every decision below was explicitly
confirmed by Evan; mechanisms marked *(engine design)* are Claude's to implement within the
confirmed architecture. Research grounding: [[karpathy-llm-wiki]], [[codex-config-surface]],
plus full surveys of claude-os, obsidian-thrive, and the personal obsidian vault.

## Prime directive

Above every structural criterion: **the system must measurably reduce repeated failures and
under-delivery.** Every component is judged by whether it serves that. Consequences already
baked in: corrections land in guaranteed-load surfaces (skill/rule/hook text), never only in
probabilistic memory; invariants are enforced by state-derived gates, never agent discipline;
configuration cannot silently fork because literals are lint failures.

## Decisions (confirmed)

**D1 — Two repos, engine vs content.** `agent-os` (engine): `setup.sh`, per-harness adapters,
hook scripts, drift checks, dependency materializer — code only. `vault` (content): everything
an agent reads — rules, skills, workflows, config contract, wiki, memory, log. Placement test:
*code that wires a harness → agent-os; content an agent consumes → vault.* Skills-vs-workflows
ambiguity cannot arise: both are markdown, both are vault.

**D2 — One vault, both machines.** New repo `Heisler-Studio/vault` (the Heisler Studio GitHub
org owns both new repos — `agent-os` moves there too; Evan's correction `log: 2026-08-20`);
`obsidian` and `obsidian-thrive` archived read-only as history. No IP constraint.
`obsidian`/`obsidian-thrive` named the viewer, not the thing — same defect class as `claude-os`.

**D3 — Env = context; flat everything.** Contexts are `work` and `studio`. Context exists in
exactly one place: the config contract under `os/config/`. Wiki flat, log single, memory flat —
no context subtrees, no context frontmatter. Naming (Evan's correction `log: 2026-08-20`): "personal" was shorthand for "not work" — a
negative definition. The context IS Heisler Studio, Evan's overarching personal brand, so the
identifier is `studio`. `work` is Thrive (f.k.a. Bionic Health). "Personal" survives only as
informal prose, never as an identifier. Rationale (Evan's, adopted after argument): every
"which bucket?" moment is a decision point agents fumble; knowledge self-identifies by content;
one grep surface beats partitioned logs. Machines are stateless install targets with one
machine-facts file. Agent accounts are projection targets, never content forks.

**D4 — Skills are singletons against a contract.** One skill library in the vault. A skill
never contains a literal (path, account, team key, board ID) — it names contract facts the
active context supplies. A context that doesn't define a skill's required facts doesn't
activate that skill. The no-literals rule is greppable and enforced by `--check`. This kills
the `ship-issue` fork class (two copies drifting apart) and the "skill isn't installed /
hardcoded path" failure class in one move.

**D5 — Third-party skills: declare, wrap, patch.** A dependency manifest in vault content
declares each third-party skill (source: plugin marketplace | skills CLI | git; pinned
version). The engine materializes identically on every machine. Customization, in priority
order: (1) wrapper skill in the vault invoking upstream (the `grill-with-docs` → `grilling`
pattern; upstream stays pristine, updates free); (2) patch file in the vault, applied at
install, re-applied on update, failed re-apply = drift. Editing upstream in place stays banned;
drift check asserts installed tree = manifest + patches. Generalizes the deleted
`MODEL_INVOCABLE` mechanism without hand-enumeration — the patch directory is the list.

**D6 — Full Claude + Codex parity in v1.** Codex now has lifecycle-hook parity (11 events,
same JSON shape — https://learn.chatgpt.com/docs/hooks) and reads Claude's `SKILL.md` format
from `~/.agents/skills` (see [[codex-config-surface]]). All 9 hooks register in both
harnesses; one skill library serves both; AGENTS.md projection follows the OS → context → repo
hierarchy. Open-weight harnesses: documented extension point only.

**D7 — Linear vs Notion.** The test: **does it touch code? → Linear** (work account and
Heisler Studio account; the studio workspace exists and implements only the contract subset — team
key, `ready-for-agent`/`ready-for-human` labels, status mapping, board linkage; no work
ceremony). **Freeform resources and life-admin → Notion** ("make a doctors appointment", not
"configure SnapTrade MCP"). Both stay; the test decides, not the tool.

**D8 — Notion is a first-class second-brain citizen, structurally Evan's.** The agent reads
and edits within Evan's pillar structure (life, work, travel, …) but never owns the shape.
Not exclusively read-only — edits are expected. Access mechanism *(engine design)*: evaluate
direct API against current MCP limits and the incoming Notion CLI/MCP; the manifest model makes
the mechanism swappable without touching skill content. Recorded direction, not v1: a custom
Obsidian plugin dashboard over the vault surfacing Notion, calendars, and Linear — the design
must not foreclose it.

**D9 — Session close is a hard Stop-gate.** A Stop hook blocks ending any session whose state
shows dirty vault content or fired corrections until the log entry + distillation exist.
Condition derives from state, never agent self-report. Read-only sessions are unaffected
(nothing dirty). Replaces "skippable skill + after-the-fact auto-snapshot", which committed
without distillation exactly when the loop mattered.

**D10 — Weekly `/retro`.** A vault skill, engine-scheduled (routines/cron on both machines):
mine the week's log entries, corrections, and hook denials for repeated failure shapes. Every
finding must terminate in a **landed fix** (skill edit, rule change, new hook) — never a
findings report. Anything needing Evan's decision becomes the week's one queued question.
Same engine-schedules/vault-defines split applies to `/lint`.

**D11 — Memory curated at the migration gate.** All 172 memory files (156 thrive + 16
personal) plus the stranded corpus at `~/.claude/projects/-Users-evanheisler/memory` get
audited during migration: every feedback memory checked against the skill/rule it should have
landed in and distilled there; only memories with independent residual value cross over; the
rest stay archived in the old repos. The migration rewrites every skill anyway (D4), so this
is the one near-free moment for the audit.

**D12 — Log: append-only forever.** Merge = interleave both logs by date; same-date entries
disambiguate by title (existing convention). No compaction mechanism, matching Karpathy's
design deliberately: the wiki is the compaction layer, distillation is the cleanup, and `log:`
citations make pruning a provenance-destroying act. See [[karpathy-llm-wiki]].

**D13 — Staged cutover.** Build agent-os + vault to completion in parallel while claude-os
stays live. Personal machine cuts over first and shakes down under real sessions; work machine
follows; claude-os stays bootable until Evan declares it dead. Rollback = re-run claude-os
`setup.sh`.

## Mechanisms *(engine design)*

### Config contract

- `vault/os/config/schema.md` — defines every fact name a context may supply, its shape, and
  which skills require it. The schema is the contract; contexts are instances.
- `vault/os/config/work.md`, `vault/os/config/studio.md` — the instances. Work supplies:
  Linear workspace + team `BH`, GitHub org `Bionic-Health`, repos, board/field IDs, Grafana/
  PostHog wiring, Figma file, identities. Studio supplies: the Heisler Studio Linear
  workspace facts (team `ENG`), Heisler Studio repos, Notion wiring, identities.
- **Machine facts** live in one engine-owned local file (successor of `~/.claude/os.json`):
  vault path, local repo paths, default context, installed-harness inventory. Never committed;
  everything derivable is derived, only true local facts stored.
- **Secrets: 1Password is the universal repository** (Evan's requirement, `log: 2026-08-20`).
  Config and contract files carry only `op://` references, never token values. Credential
  files that tools force to exist on disk (e.g. the Linear CLI's `credentials.toml`) are
  derived state the engine materializes from 1Password at setup — op is the source of truth,
  and a token value appearing in any committed file is a lint failure.
- **Active-context resolution:** the session's repo maps to a context via a repo→context table
  in config; no repo match → the machine's default context. No agent judgment involved.

### Adapters

One content tree, projected per harness by the engine:

| Surface | Claude Code | Codex |
|---|---|---|
| Rules/instructions | `~/.claude/CLAUDE.md`, output style, prompt-inject hook | `~/.codex/AGENTS.md` pointer (bridge pattern, no copying) |
| Skills | `~/.claude/skills/` symlinks | `~/.agents/skills/` symlinks (native `SKILL.md` support) |
| Hooks | `settings.json` fragment merge, `~/.claude/os/hooks/` namespace | `~/.codex/hooks.json`, same 9 scripts, harness-neutral script paths |
| Permissions | `settings-permissions.json` wholesale | `config.toml` fragment merge |
| MCP | per-harness registration from one manifest | same |

Hook scripts move to an engine-owned harness-neutral location so `HOOK_NS` no longer encodes
"claude"; the installer carries one-time migration code that prunes old-namespace entries from
`settings.json` (the survey showed pruning keys on the namespace string).
Rule text is written person-neutral where trivial, but "Evan" stays where the rules are
genuinely addressed at one person — templating for its own sake is machinery ahead of need.

### Enforcement invariants (each lands in `--check` with an injected-fault proof)

1. No literal machine paths, accounts, team keys, or board IDs in any skill/config body
   (grep-based; the D4 rule).
2. Installed third-party tree = manifest + patches; dangling symlinks are drift (closes the
   `receipts` leak).
3. Docs-vs-mechanism drift: any mechanism named in vault/os docs must exist in the engine
   (closes the `MODEL_INVOCABLE` stale-doc class).
4. Hook parity: every hook registered for Claude is registered for Codex, or carries an
   explicit per-harness exemption in the manifest.
5. Session-close gate fires on injected dirty state.

### Migration stages (tracked in studio Linear — touches code)

**Cross-cutting constraint (Evan's correction `log: 2026-08-20`): no stage before a cutover
mutates any live machine's installed state.** All engine proofs run in a sandbox HOME (the
installer targets a temp dir; drift checks and injected-fault proofs run there). Migration
code — settings rewrite, hook re-namespace, credential materialization — ships dormant and
executes only during a cutover. Each cutover ends with a **delta sync**: everything the old
vaults accumulated after vault assembly (log entries, memories, wiki edits) is re-merged, so
nothing written during the build window is lost. Rollback at any point = re-run claude-os
`setup.sh`.

1. Spec approval (this page) → create `Heisler-Studio/vault`; rename `evanheisler/claude-os`
   → `agent-os` and transfer it to the `Heisler-Studio` org (rename + transfer keep history
   and redirects; D2's fresh-start applies to the vault, not the engine).
2. Engine rebuild: de-literalize, adapter split, hook-namespace migration, dependency
   manifest, enforcement invariants above.
3. Vault assembly: stamp kernel; carry both wikis (29 pages, disjoint); interleave logs;
   **memory audit (D11)**; port all skills to contract singletons; write `schema.md` +
   both context instances.
4. Personal-machine cutover + shakedown under real sessions.
5. Work-machine cutover.
6. Archive `obsidian`, `obsidian-thrive`; declare claude-os-as-was dead.

## Glossary (sharpened this session)

- **engine** — agent-os: code that wires harnesses. **content** — vault: markdown agents read.
- **context** — work (Thrive, f.k.a. Bionic Health) | studio (Heisler Studio); a
  config-contract instance, never a directory of knowledge.
- **contract** — the schema of named facts skills may reference; contexts supply values.
- **projection / adapter** — rendering one content tree into a harness's native config surface.
- **machine facts** — the only per-machine state: local paths + default context, one file.
- **touches code** — the Linear/Notion routing test.

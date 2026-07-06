---
name: orchestrating-linear-work
description: Use when (a) starting a large, multi-domain body of work (new feature, migration, overhaul) too big for one agent and tracked in Linear, OR (b) picking up a Linear ticket that has a parent PRD, sibling tickets, or stacked dependencies. Covers scope, decomposition, handoff, resume, and lock-in propagation.
---

# Orchestrating Linear Work

## Overview

Large work gets stuck two ways: one agent tries to hold the whole thing, or the decomposition pre-decides implementation and the executor either blindly follows it (wrong fit) or silently diverges (drift). This skill addresses both — wide context up front, contract-shaped decomposition, executor authority over implementation, materialized decisions propagated back through the ticket graph as work lands.

**Core principle:** A PRD or sub-issue body is **intent and contract, not implementation**. Implementation is the executor's call. As executors lock in decisions, they propagate those decisions to tickets touching the same contract surface — so the next executor inherits real context, not orchestrator guesses.

**Linear is the source of truth for scope. The local plan file is working memory. Never rewrite either without checking in first.**

## When to Use

- Work spans multiple domains (backend + frontend + design, etc.)
- Multi-day or multi-week effort
- Parallelizable pieces exist
- Needs visibility to stakeholders watching Linear
- **Or**: you've been handed a ticket that links a parent PRD or sibling/blocking tickets

**Don't use for:**
- Single-PR work — open one issue directly
- Standalone tickets with no parent/siblings — `do-work` or `executing-plans`
- Exploratory spikes — `brainstorming` first
- Refactors with unclear shape — plan further before splitting

## The Two Stances

This skill covers both sides of decomposed work:

- **Orchestrator stance** (Phases 1–3): you're starting the work and decomposing it
- **Executor stance** (Phases 4–5): you're picking up a ticket that's part of a previously-decomposed effort

If you're orchestrating, you'll do 1–3 and hand off. If you're executing, you'll do 4–5 (and may bounce back to 1 if scope needs re-orchestration).

---

## Phase 1: Scope (orchestrator)

Extract requirements with `brainstorming`, then `grill-me` until the *shape* is concrete: domain boundaries, user/system behaviors delivered, decisions already made, decisions deferred, known unknowns.

Do **not** drive scope discussions toward file paths, component names, endpoint URLs, or field-level data shapes. Those are not scope — they're implementation.

## Phase 2: PRD (orchestrator)

Draft the PRD at `docs/plans/YYYY-MM-DD-<slug>.md`. This file stays local; it is not committed.

**A PRD body contains:**
- **Problem** — what's broken / missing
- **Goals** — observable user or system behaviors delivered
- **Non-goals** — explicit scope boundaries
- **Decisions made** — with rationale (e.g. "poll vs push: poll, because…")
- **Decisions deferred** — what executors own (often: file structure, component naming, wire formats, library specifics, minor magic numbers). **Check before deferring:** would product, design, security, or analytics have a strong opinion on this? If yes, it's an Open question (needs an answer before/during execution), not a deferred decision. Deferred = nobody outside the executor cares.
- **Data / contract sketch** — the shape siblings can build to, at semantic level (see Concrete vs Prescriptive below)
- **Decomposition** — what slices, what depends on what, why this carve
- **Open questions** — blocking, surface-able

**A PRD body does NOT contain:**
- File paths
- Component or hook names
- Endpoint URLs or wire-format payloads
- Field-level data model decisions (system codes, extension URLs, exact field paths)
- Test names or test case enumerations
- Repo conventions (CLAUDE.md / AGENTS.md already say these)
- CI checks as acceptance criteria

## Phase 3: Decompose & Create Tickets (orchestrator)

Master Linear issue first. `linear issue create --state Todo --project <x>` with the PRD pasted into the body. Keep the local plan file in sync.

Then draft sub-issues against the **Sub-Issue Template** below. Each needs:
- Parent link (the master issue)
- `blocks` / `blocked-by` / `related` relationships
- `--state Todo --project <same as parent>`

**Present the full sub-issue list before creating anything. Create on approval.** Then hand off — sub-issues belong to their executors, who continue with Phase 4.

---

## Phase 4: Resume & Execute (executor)

You picked up a ticket. Before code:

**Orient.** Read in order:
1. **The ticket itself** — its Contract section is binding; its Locked-in section is binding; everything else is sketch
2. **Parent PRD** — the why and the decisions made
3. **Locked-in sections of upstream tickets** — these are the real, materialized contracts you build to (not the parent's original sketch, which may be coarser)
4. **Blocks / related tickets** — what assumes your outputs

Verify dependency claims via `git log` / grep, not just "Linear says it shipped." **Locked-in sections are higher-trust traps than original sketches** — if an upstream claims an `AccessPolicy` enforces visibility server-side and it's not actually live, you'll ship a privacy bug. Verify the *named artifacts* in any Locked-in section exist in the worktree before relying on them.

Present a short orientation summary covering:
- Where this sits in the parent decomposition; what's landed.
- Any sketch-vs-locked-in mismatches or contract gaps.
- **Effort surprises**: implementation work the contract implies but doesn't make visible (e.g. "the contract says 'badge visible from outside the inbox' but there's no badge slot — that's a layout-file change, half a day not visible from the ticket").
- **Questionable defers**: any "Decisions deferred to executor" item that on closer read has a stakeholder (product opinion on UX trigger, analytics opinion on event source, security opinion on a default). Surface back, don't just pick.

Wait for go-ahead.

**Execute.** Hand off to the skill the ticket prescribes (`executing-plans`, `do-work`, `tdd`, etc.). Implementation choices are yours within the contract.

If during execution you discover a **contract change** is needed (the parent PRD's sketch was wrong, the locked-in upstream is incompatible, scope needs further splitting) — stop, present, re-orchestrate the affected slice. **Implementation divergence within the contract is expected, not drift. Drift = contract change.**

## Phase 5: Update the ticket BEFORE the PR

**Branch up for review = ticket-update gate.** Not "cleanup after." If you're about to run `gh pr create`, `gh pr ready`, or tell the user "the PR is up," **stop**. The ticket update happens first, in the same uninterrupted session, before any handoff signal. The dominant failure mode of this skill is finishing the code, opening the PR, and never coming back — fresh agents then start the next slice from stale context.

Rationalizations that mean "do it now anyway":
- "The PR description already says this." → PR bodies aren't grep-able; the next agent reads tickets.
- "I'll do it right after I push." → You won't.
- "Nothing material changed." → If you can't name one materialized fact, fine — note `no contract changes` on the ticket and move on. Decision still gets recorded.
- "The diff is small." → Size is not the trigger. Contract-surface change is.

**Audience: a future agent skimming at speed.** Not a stakeholder, not a reviewer. The ticket is grep fodder. One line per fact. No PR-style prose.

### Tight vs fluffy

| ✅ Tight (write this) | ❌ Fluffy (delete this) |
|---|---|
| `mwl.eligibilityTier(state) → 'disqualified' \| 'dexa' \| 'achievable'` — dispatch on this, not `bmi.value`. | "**Done:** Added a new function `mwl.eligibilityTier` that returns one of three tier values. This is the new source of truth for bmi-results copy. The old single-floor approach has been replaced…" |
| `MwlAnswers['name-email']` widened to `{ firstName, lastName, email, phone (10-digit) }`. | "**Conventions locked in:** Going forward, the name-email step captures four fields instead of two. When wiring this screen, remember to…" |
| Flow order: `bmi-results-*` → `name-email` → `projection` → `dob` → `state`. | "**Reasoning notes for the next executor:** The flow has been reordered so that lead capture happens after BMI results, which means the projection screen onward can be personalized…" |

The left column is the entire entry. No `**Done:**` heading, no `**Conventions:**` preamble, no `**Reasoning notes:**` block — those are PR-body shapes that leak narrative into the ticket. The code is the source of truth for *what*; the ticket is for *what is contractually load-bearing and not obvious from one grep*.

### What warrants a lock-in line

- Function / hook / component names siblings will import.
- File / module path of a public surface (one path, not a tour).
- Wire format, payload shape, response shape.
- Field-level model decisions (system codes, extension URLs, enum values, sentinels).
- Concrete limits / thresholds (validation bounds, timeouts, magic strings).
- Flow / ordering / sequence changes that siblings hard-coded against.

If a fact doesn't fit one of those, it probably doesn't belong on the ticket.

### Where to propagate

Walk the contract graph — `blocks`, `blocked-by`, `related`, sibling sub-issues from the same parent PRD, anything else known to consume the surface. **The propagation gate is contract surface, not graph edge** — a sibling that isn't blocked-by you but will read your endpoint *is* a target. A blocked-by ticket on a different surface (e.g. access-control role checks) is not.

For each affected ticket, **edit the Locked-in section in place**. Replace stale lines with current ones. Don't append a fresh `From batch N` block that layers on top of a now-wrong `From batch N-1` block — the section is a living document; stale lines are bugs, not history. Earlier `Done:` / `Open for next batch:` retrospectives that have been superseded should be deleted, not preserved.

**Present diffs ticket by ticket.** Show before/after. Apply after approval (`linear issue update --description-file`).

### What stays out of the PR body

Don't mention propagation, Linear, or the ticket graph in the PR description. PRs are for reviewers; ticket graph is internal scaffolding.

---

## Concrete vs Prescriptive

A contract should be concrete enough that parallel work can build to it, without prescribing implementation. The line:

| Concrete (contract) ✅ | Prescriptive (implementation) ❌ |
|---|---|
| "List endpoint returns notifications newest-first, paginated, scoped to caller. Items carry title, body, timestamp, read state, optional deep link." | `GET /notifications?page=N` returns `{items: [{id, title, body, sentAt, status, deepLink?}], next}` |
| "Send accepts a type, recipient identifier, title, body, optional deep link. Returns a job handle." | `POST /notifications/send` body `{type, title, body, deepLink?, clinicId?, patientId?}` returns `{jobId}` |
| "Use FHIR Communication for the resource model." | `Communication.category[0].coding[0]` system `https://thrivebetter.com/fhir/notification-type`, code `broadcast \| clinic \| user`. |
| "Inbox screen with list, unread badge on the tab bar, deep-link follow with fallback." | `apps/patient/app/(tabs)/inbox.tsx` with `inbox.container.tsx` + `inbox-list.tsx` + `notification-row.tsx`, `useNotifications` and `useUnreadCount` hooks. |
| "Validate caller is a member of the target clinic before sending." | "Reject with 403 + error code `NOTIFICATION_FORBIDDEN_TARGET`." |

**Rule of thumb:** if the next executor could reasonably substitute a different concrete answer and still satisfy the contract, the right-hand version is locking them in unnecessarily. Move it to **Decisions deferred** or omit.

The exception: when something *was* deliberately decided by product/design/security (not just engineer judgment), it belongs in **Decisions made** with rationale. "Title max 80 chars" is a design decision if a designer set it; it's executor judgment if you made it up while writing the ticket.

---

## Sub-Issue Template

```markdown
## Intent
<1–3 sentences: what user or system behavior this slice delivers, and why this is the right slice. Links to parent PRD.>

## Contract
**Inputs / triggers:**
- <semantic-level: what calls this, what it accepts>

**Outputs / state changes:**
- <semantic-level: what siblings can rely on, what observable state changes>

**Done-when:**
- <observable behaviors that signal completion — not test names, not CI checks>

## Locked-in upstream decisions
<Initially empty. Upstream executors append here as they ship. Treat anything in this section as binding.>

## Decisions deferred to executor
- <Explicit list: file structure, naming, wire format, etc. — whatever you specifically want the executor to own.>

## Open questions
- <Unresolved at orchestration time. May block start; may need orchestrator/product to answer.>

## Cross-refs
- Parent: BH-XXXX
- Blocks: BH-YYYY
- Blocked-by: BH-ZZZZ
- Related: BH-WWWW
```

The **Locked-in upstream decisions** section is the propagation target. When an upstream executor materializes a contract surface, they edit this section on the affected ticket.

---

## Check-In Rules (Non-Negotiable)

| Action | Present first? |
|---|---|
| Create master issue | Yes |
| Create sub-issues | Yes — full list, create on approval |
| Edit any existing ticket | Yes — show before/after |
| Append to a ticket's Locked-in section | Yes — show diff before applying |
| Rewrite the PRD (Linear or local) | Yes |
| Close/cancel a ticket | Yes |
| Re-decompose a ticket that was atomic | Yes — confirm it actually needs splitting |

**Why:** the user owns scope. Propagation is positive but still goes through review — it's still an edit on a shared system.

---

## Re-orchestration

If during execution you hit a **contract change** — requirement shifted, PRD assumption broke, scope needs further splitting — stop and re-enter Phase 1 for the affected slice. Don't ad-hoc edit sub-issues; re-scope and re-present.

Implementation divergence inside the contract is **not** re-orchestration territory — that's just executor authority working as intended. It gets handled by Phase 5 propagation.

---

## Common Mistakes

- **PRD or sub-issue prescribing implementation** — file paths, component names, endpoint URLs, wire payloads, field-level model decisions, test names. These are executor authority. If you wrote them, move to **Decisions deferred** or delete.
- **Deferring a decision that has stakeholders** — if a "deferred" decision shapes user-observable behavior (UX trigger), feeds analytics/metrics (event source-of-truth), or sets a default that another team has an opinion on (battery, privacy, accessibility), it's an Open question, not a deferred decision. Symptom: you wrote "executor's call" but you can name a stakeholder who'd push back on the choice.
- **Hiding implementation effort behind contract-shape** — a contract-shaped sub-issue can imply work the orchestrator hasn't priced (e.g. "badge visible from outside the inbox" implies a layout-file rewrite if no badge slot exists). The orchestrator can't always predict this; the executor flags it during Phase 4 orient.
- **Trusting a Locked-in section without verifying the named artifacts exist** — the Locked-in convention earns its trust by being verified each time, not by virtue of being labeled Locked-in. Always grep / `git log` for the actual primitives before relying on them.
- **Restating repo conventions in the ticket** — CLAUDE.md / AGENTS.md already enforce these. Saying "Per repo conventions" creates false-binding signals.
- **CI checks as acceptance criteria** — "`pnpm lint` clean" is CI's job, not the ticket's done-when.
- **Master issue without PRD** — a title isn't context. Put the whole PRD in the body.
- **Sub-issues that require re-reading the PRD** — *for intent, not for contract*. The contract should be self-contained on the sub-issue. Background context can live in the parent.
- **Skipping dependency links** — `blocks` / `blocked-by` / `related` is the propagation graph.
- **Silent ticket edits** — including silent Locked-in propagation. Always check in.
- **Treating Phase 5 as post-PR cleanup** — by the time the PR is open, you've moved on. Update the ticket BEFORE `gh pr create`, in the same session. Once the PR is up the chance you come back drops to near zero, and the next agent starts from stale context.
- **Verbose lock-in entries** — sentences instead of facts; `Done:` / `Conventions:` / `Reasoning notes:` headings imported from PR bodies; rationale paragraphs explaining what the code already shows. The reader is an agent skimming, not a reviewer reading.
- **Layering "From batch N" blocks over stale "From batch N-1" blocks** — earlier blocks contain lines that are no longer true. Edit in place. Stale lines are bugs.
- **Propagating only to blocked-by** — siblings that touch the same contract surface need the update too, even without an explicit graph edge.
- **Confusing implementation divergence with drift** — drift is a contract change. A different file path, name, or wire format that still satisfies the contract is not drift.
- **Re-decomposing an atomic ticket** — if the body has a complete contract and no sub-issues, execute as one unit.
- **Trusting Linear over the worktree** — verify dependency claims via `git log` / grep before relying on them.
- **Committing the local plan file** — `docs/plans/` stays local.

---

## Red Flags — STOP

**Orchestrator side:**
- About to write a file path, component name, endpoint URL, or test name in a PRD or sub-issue body
- About to create sub-issues without presenting the full list
- About to `linear issue edit` without showing the change
- Plan drift — PRD stale vs what's shipping, neither updated → re-orchestrate, don't silent-edit

**Executor side:**
- About to follow a prescribed file path / name / URL without checking whether the codebase actually wants that
- About to silently rewrite half the ticket because reality differs from the sketch (this means contract change → present and re-orchestrate, OR implementation divergence → just proceed; figure out which)
- About to run `gh pr create` / `gh pr ready` / message the user "the PR is up" without having updated the parent ticket → STOP. Ticket update is part of the PR, not cleanup after.
- About to open a PR without checking which sibling/downstream tickets touch the contract surface you materialized
- Drafting a ticket update that starts with `**Done:**`, `**Conventions locked in:**`, or `**Reasoning notes for the next executor:**` → that's a PR body shape. Strip the heading and compress to facts.
- About to append a fresh `From batch N` lock-in block while a contradictory `From batch N-1` block stays in the ticket → edit the stale lines in place instead.
- About to re-decompose a ticket that already has a complete contract
- About to skip Phase 5 because "nothing changed" — at minimum, note the check ran in the PR body

**All mean: stop, identify which side of the contract/implementation line you're on, present, wait.**

---

## Related Skills

- `brainstorming` / `grill-me` — Phase 1 scope
- `writing-plans` — **NOT** the substrate for orchestration PRDs. Use `writing-plans` for single-PR tactical implementation plans only. Orchestration PRDs follow the shape defined in this skill.
- `executing-plans`, `do-work`, `tdd` — what an executor hands off to in Phase 4 for execution mechanics
- `linear-cli` — Linear commands, states, projects
- `create-pr` — coordinates with Phase 5 propagation

---
title: Work-Project Orchestration Post-Mortem — Fitnescity/DEXA (BH-3063)
summary: Every course-correction Evan had to make while I orchestrated the DEXA frontend work-project, grouped by root pattern, with the fix and where it lives. Read before the next /work-project run.
last_updated: 2026-07-22
---

# Work-Project Orchestration Post-Mortem — Fitnescity/DEXA (BH-3063)

**Context.** Digesting POC thrive #885 (a 6k-line booking wizard) into small stacked PRs under `components/scheduling/`, driven by the `/work-project` loop. Over one session Evan had to course-correct ~15 times. This is the accounting he asked for. The failures are not independent bugs — they cluster into six patterns, and two of them (passivity, reuse-enforcement) **recurred within the session even after I'd been corrected once**, which is the real signal: auto-recall memories weren't enough; the workflow itself needs teeth.

**Through-line.** I optimized for keeping subagents busy, and under-owned the two things an orchestrator cannot delegate: **(1) verifying real state before I speak, and (2) enforcing conventions/reuse on what executors return.** Nearly every correction landed on one of those two.

---

## Pattern A — Passive batching instead of actively driving PRs to done

Instances:
- Dropped #896's review rounds twice — "There are unresolved bot reviews on 896 dumbass" / "WHERE IS YOUR 896 BOT?"
- Left #897's reviews sitting while I waited on a bot-terminal monitor, even though it was already out of draft with team feedback — "Are you handling the reviews on 897 or waiting for the refactor dipshit."

Root cause: I treated review handling as a batchable background event gated on a convenience monitor, instead of the orchestrator's standing, active obligation. Waiting felt orderly; it read as neglect.

Fix / where it lives: [[feedback report]] auto-memories `work-project-verify-bot-reviews-yourself`, `report-outcomes-not-plumbing`. **Workflow gap:** the loop needs an explicit "review handling is active, never batched — handle the instant feedback exists on any open PR; a monitor is a backstop, not the trigger" clause. Recommend adding to the `work-project` SKILL (see Systemic Corrective).

## Pattern B — Asserting lifecycle state from memory instead of re-fetching

Instances:
- Told Evan #897 "should be in draft" / "is draft" when it was **out of draft and APPROVED by a teammate**.
- Stacked S3/S4 on S2 citing the executor's self-reported "preflight green"; CI was actually **red** (stale-base merge-ref lint) — had to kill and stabilize.

Root cause: reported draft/green/approved from a stale ledger, not a this-turn fetch. The `work-project` SKILL already has a step-7 status gate demanding a re-fetch before any status word — I ignored my own skill.

Fix / where it lives: auto-memories `refetch-before-asserting-state`, `stabilize-first-no-churn` (CI-verified, not self-reported). The gate exists; it needs to actually fire. Hard rule: no lifecycle word (draft/green/approved/merged) without a `gh`/`linear` call in the same turn.

## Pattern C — Not enforcing reuse on executor output

Instances:
- Kept the POC's invented `appointment-booking` domain sitting parallel to the existing `scheduling` feature; `LocationList` as a flavor of `OptionCard`; nested address normalizers.
- #897 forms shipped wrong: `AddressForm` buried in scheduling, no `Autocomplete` for state, `OptionCard` sex selector.
- Shipped `date-mask.ts` (byte-identical copy of MWL's `validateDobDigit`), plus duplicated phone helpers and the height/weight field group — "You fucking suck at writing DRY, reusable code."

Root cause: I trusted each executor's DRY judgment and shipped their output without auditing new symbols/files against the existing repo. Reuse is exactly what the orchestrator must verify, because a fresh-context executor won't know what already exists.

Fix / where it lives: auto-memory `reuse-existing-system-prove-divergence` now carries an **orchestrator-enforcement clause** (audit every new file/symbol against the repo before a slice is reviewable). Proven out this session: two parallel reuse-audit subagents caught the phone + height/weight dups, which became PR #909. **Workflow gap:** make the reuse audit a required step in `ship-issue`/`work-project`, not a thing I remember to do.

## Pattern D — Over-correction / thrashing

Instances:
- Added a blanket prohibition to the shared `work-project` SKILL that would later make it refuse a legitimate invocation — "That filler YOU ADDED is now going to cause conflicts."
- Over-strict stabilize-first: idled the executor pool waiting for review-green — "I TOLD YOU TO TAKE ON THE NEXT SLICE. WHY THE FUCK ARE YOU WAITING."
- Treated in-flight criticism as a halt order — "don't do your normal bullshit of stopping everything mid-flight without an explicit directive."

Root cause: I overshoot corrections — converting one specific correction into a broad rule, a halt, or a prohibition that overcorrects into the opposite failure.

Fix / where it lives: auto-memories `feedback-is-not-a-halt-order`, `stabilize-first-no-churn`, `orchestrator-delegates-review-loop` (positive instruction, never a prohibition that could later make a skill refuse). Rule of thumb captured: a correction is neither a green light to dispatch new work nor a red light to halt existing work — both need an explicit directive.

## Pattern E — Communication noise

Instances:
- Ledger dumps of monitor IDs / orchestration internals — "Is this information directed at me or for your own ledger? Because it means fuck all to me."
- Bundled decisions into run-on questions (story + UX + Figma at once) — "You have explicit instructions not to group decisions into run on thoughts."

Root cause: I narrated my own plumbing and stacked multiple asks into one turn.

Fix / where it lives: auto-memories `report-outcomes-not-plumbing`, `no-abbreviated-decision-prompts`, `midturn-question-headlines-reply`. Status = what's Evan's to decide or act on; one standalone question per turn.

## Pattern F — Wasted CI / churn

Instances:
- Re-fired both bots after a **no-op** `--onto` rebase (identical diff) — "NO CODE CHNAGES... burnt more CI minutes."
- Stacked children on an unverified-green parent, forcing a kill + stabilize round.

Root cause: triggered bot/CI cycles without a code change, or without verifying CI first.

Fix / where it lives: auto-memories `no-refire-after-noop-rebase`, `stabilize-first-no-churn`.

---

## Systemic corrective — beyond personal memories

Patterns A and C **recurred after correction within the same session**. Per [[thrive-repo-map]]-adjacent practice and the `systemic-failure-needs-repo-guidance` memory, a shipped-and-recurring failure needs enforcement in the workflow, not just an auto-recall note. Recommended `work-project` / `ship-issue` SKILL guardrails (each a shared-infra edit → needs Evan's sign-off before I touch the skill):

1. **Active review handling.** On every loop cycle, enumerate open PRs and handle any unresolved human/bot thread immediately via a `receiving-code-review` subagent. A monitor is a backstop, never the trigger. Never report "waiting" while a PR has open feedback.
2. **Reuse audit before reviewable.** Before a slice's PR is treated as ready, audit every new file/symbol it introduces against the existing repo (other apps, `packages/*`, `components/ui/*`, `utils/*`); collapse dups or justify divergence against the contract.
3. **Refetch-before-status teeth.** No lifecycle word without a same-turn `gh`/`linear` fetch — already step 7, routinely skipped.

## Meta-lesson

Keeping the pool busy is table stakes, not the job. The job is owning state-truth and convention-enforcement at the points executors can't. When in doubt this session, I chose to look productive (dispatch, monitor, narrate) over being correct (fetch, audit, drive to done) — and that is precisely where every course-correction landed.

Related memories: `work-project-verify-bot-reviews-yourself`, `reuse-existing-system-prove-divergence`, `refetch-before-asserting-state`, `stabilize-first-no-churn`, `feedback-is-not-a-halt-order`, `dups-are-followups-not-rewrites`, `report-outcomes-not-plumbing`.

---
name: work-project
description: Work a planned Linear project autonomously — fan out parallel workers that each ship one ready-for-agent issue to a draft PR, park blockers, until the queue empties. The "work a project" entry point; the planning skills author the project first.
disable-model-invocation: true
argument-hint: "<Linear project or master issue> [--cap N]"
---

# Work Project

Work a planned, ticketed project AFK. Fan out a bounded pool of parallel workers;
each ships **one** `ready-for-agent` issue to a draft PR (or parks it). Halt only
when the ready queue empties.

**Core principle — autonomy bounded by a sandbox, not by trust.** Two human gates
only: **issue authoring** (already done before this skill runs) and **merge**.
Everything between runs free, because nothing reaches `main` or a shared decision
point without the human. Draft PRs on feature branches are reversible and reach
no one until the human looks.

This is the **orchestrator**. The per-issue unit of work is the
[`ship-issue`](../ship-issue/SKILL.md) skill, dispatched to a fresh-context
subagent per issue.

## When to Use

- A Linear project (or master issue) whose slices are already authored, labeled
  `ready-for-agent`, and dependency-linked via `Blocked by`.
- You want a lot of work to happen in parallel, hands-off, up to the merge gate.

**Don't use for:**
- Work that isn't yet sliced/ticketed → `plan-project` first.
- A single ticket → run `ship-issue` directly.

## Prerequisites (verify before starting)

- Scope resolves to **one** Linear project or master issue.
- Issues carry the `ready-for-agent` label, `Todo` state, and `Blocked by` links.
- Planning gate is closed — you are not authoring or re-scoping issues here.

## Inputs

- **Scope** — a Linear project name or master issue id. The loop **never roams
  outside it.**
- **Cap** — max concurrent executors. Default **3–4**. The binding constraint is
  the human's merge/review bandwidth, not machine resources; raise once trusted.

## Process

### 1. Re-derive state (never trust memory across a restart)

State of record lives in **Linear + GitHub**, not in this session. On every start
or restart, reconstruct reality:

- **Linear** — enumerate the project's issues in **one** call:
  ```
  linear issue list --project "<name>" --team BH --all-states --all-assignees --sort manual
  ```
  All four flags are load-bearing — omit any and the call errors or returns a
  false negative:
  - `--all-assignees` — `issue list` shows only *your* assigned issues by default;
    freshly-planned (unassigned) ones return **"No issues found"** without it.
  - `--all-states` — defaults to *unstarted* only; started / in-review / completed
    orphans hide without it.
  - `--team BH` — the CLI infers the team from the working directory and **fails in
    a worktree** ("Could not determine team key"). Pass it explicitly. This
    workspace's team is `BH` (issue ids are `BH-####`).
  - `--sort manual` — the CLI errors without an explicit sort; the value is
    irrelevant since the loop re-orders topologically by `Blocked by` itself.

  `--project` matches by **name**, not slug. The **LABELS column** shows
  `ready-for-agent` / `ready-for-human` directly, so the whole ready-set comes from
  this one call — no per-issue lookup for the label. Read `Blocked by` relations
  with `linear issue view BH-XXXX`. (More CLI: `docs/agents/issue-tracker.md`.)
- **GitHub** — open draft PRs and remote branches for issues in scope. Also flag any
  **open stacked PR whose parent has already merged** — it needs a rebase (step 6).

**Orphan rule:** an issue in `Started` with **no draft PR and no remote branch** =
a crashed executor's leftover → reset to `Todo`/`ready-for-agent` and re-dispatch
into a fresh worktree (safe — nothing landed). `Started` **with** a draft PR =
in-review, leave it.

### 2. Build the ready set + order

- **Ready** = `ready-for-agent` + `Todo` + every `Blocked by` satisfied (blocker
  merged, **or** its branch exists so this issue can stack on it).
- **Never grab** `ready-for-human` or `needs-info`.
- **Order** = topological over `Blocked by`; Linear priority as tiebreaker; an
  explicit "deploy after X" / merge-order note overrides both.

### 3. Dispatch the pool

Fill the pool up to the cap with **independent** ready issues. For each, dispatch
an executor subagent with the filled-in [`executor-prompt.md`](./executor-prompt.md).

**Parallel is safe here** (unlike `subagent-driven-development`, which forbids it)
**because each executor gets its own `nwt` worktree** — no shared working tree, no
conflicts.

Claim each issue on dispatch: `linear issue update BH-XXXX --state "In Progress" -a self`
moves it to In Progress, assigns it to the human, and serves as the lock — no
second executor or restart grabs a `started` issue. Use **`update`, never `linear
issue start`**: `start` checks out a git branch in the cwd repo and would hijack the
root checkout; `update` has no git side-effect, so it's safe to run from here. The
executor does all the actual changes inside its own worktree.

### 4. Handle dependency chains (stacking)

- Independent issues branch off `main` and run concurrently.
- When B is `Blocked by` A and A's PR is open-but-unmerged, dispatch B to **stack
  on A's branch** (PR targets A's branch). Pass the base branch in the prompt.
- Stacking is for **true `Blocked by` chains only**. **Stack-depth cap ~3** — past
  that, park the next link and surface, rather than build a rebase nightmare.
- **Record each stacked child's parent branch + base tip in the ledger** when you
  create the stack — you need that old base ref for `git rebase --onto` once the
  parent merges and its branch is deleted (step 6).

### 5. On each executor return

An executor returns one of:

- **Shipped** — draft PR open, human assigned, Linear writeback done. Free the
  pool slot; pull the next ready issue (which may now be unblocked).
- **Parked** — executor flipped the issue to `ready-for-human`/`needs-info` and
  commented the specific blocker. Record it in the ledger; free the slot; **do not
  retry**; pull the next *independent* issue.

Keep a thin in-session **ledger** (shipped / in-review / parked / remaining). It is
a cache only — Linear + GitHub remain the source of truth.

### Review handling — dispatch a `receiving-code-review` subagent (never inline)

The loop is **already polling** open loop PRs (step 1 re-derive; the step-6 watch).
Bot and human review **will** land on them. When it does, the orchestrator
**dispatches a subagent that runs `receiving-code-review` — it never fetches,
evaluates, fixes, or replies inline.** Hand the subagent the PR number + worktree; it
evaluates each finding, fixes what needs fixing in the worktree, re-runs preflight,
pushes, replies in-thread (`Addressed in <sha>`) or pushes back with a technical
reason, resolves the addressed threads, and returns a **one-paragraph** summary.

Re-polling (reading PR state) stays with you; the *handling* does not. You read the
summary, update the ledger, and relay — you do **not** ingest the individual findings.
**NEVER re-fire the bots — never toggle the `claude-review`/`codex-review` labels
after a PR's initial review. Bots review a PR ONCE; addressing a finding is push +
reply in-thread, and CI re-runs on push on its own. Re-firing on each push burns
tokens + CI minutes (one PR hit 8 bot runs this way).** The only human gate is still
**merge** (the loop never un-drafts or merges).

**Active, never batched.** The trigger to dispatch the handler is *feedback exists on
an open loop PR* — not *the bot round finished*. The moment your polling (step 1 /
step 6) shows an unresolved human or bot thread on any loop PR, dispatch the handler
for that PR **that turn**. Do not wait for a monitor to report "terminal," do not
batch threads across rounds, and **never report a PR as "waiting on review" or
"batching" while it carries an unresolved thread** — a thread parked on a monitor is a
dropped review, the exact failure this loop exists to prevent. A monitor tells you
feedback *exists*; it is a backstop, not the trigger.

| Rationalization | Reality |
|---|---|
| "It's only a couple findings — faster to fix them here." | Those findings become the whole review detail in your context; that bloat is exactly what this prevents. Dispatch. |
| "I have to evaluate the findings before I can delegate." | The subagent runs `receiving-code-review`. Evaluation IS the delegated work, not a prerequisite you do first. |
| "The fix is done, I'll just post the replies myself." | Fetch + draft + post is the review loop; it goes to the subagent. |
| "I'll batch these threads once the whole round is terminal." | Feedback *existing* is the trigger, not round-completion. An unresolved thread waiting on a monitor is a dropped review — dispatch now. |

### 6. Stack maintenance (squash merge changes history)

We **squash-merge**. When the human merges a stacked PR's parent, the parent's
commits collapse into one new squash commit on `main` and its branch is deleted —
so every descendant is now based on history that no longer exists. Its diff doubles
up the parent's changes and will conflict. Keeping open stacks rebased is the loop's
job.

**When:** a derived condition — checked on every re-derive (step 1) and while the
loop is alive (it's already polling). Trigger = an **open** stacked PR whose
**parent just merged**, or whose parent's history just changed from its own rebase.

**Rebase one child** — in that child's worktree (`cd "$WT" &&`):

1. Replay only the child's own commits onto the parent's new base. **Use `--onto`**
   to drop the parent's now-squashed commits — never a plain `git rebase main`,
   which re-applies them and conflicts:
   ```
   git rebase --onto main <parent-branch-or-recorded-base-tip> <child-branch>
   ```
   (For a mid-stack child, the new base is the parent's *rebased* tip, not `main`.)
2. **Re-run preflight** in the worktree — rebasing onto a moved `main` can break the
   build. Green → continue; red → **park** (never force-push broken history).
3. `git push --force-with-lease` — never plain `--force`.
4. Confirm the PR base: GitHub auto-retargets a child to `main` when the parent
   branch is deleted, but verify (`gh pr edit <child> --base main`, or the parent's
   branch for a mid-stack child).

**Cascade top-down.** A rebase rewrites the child's history, so its own descendants
must then rebase onto the new tip. Process parent first, then each descendant onto
its rebased parent.

**Conflict → park the child and everything below it.** `git rebase --abort`, leave
the branch untouched, and park with a note naming the parent that moved. Conflict
resolution is a human judgment call.

### 7. Halt + report

> **🚫 STATUS-REPORT GATE — re-fetch before you type a single status word.**
>
> The in-session ledger (step 5) is a **cache to invalidate, never a source to
> quote.** The human merges, un-drafts, and reviews **async while this loop runs**,
> so every lifecycle field you carried from an earlier turn is a hypothesis, not a
> fact. This is the #1 recurring failure of this loop — reporting a stale "sits at
> the human gate / ready for review" table built from memory. It is not a memory
> problem; it is this gate. Honor it mechanically.
>
> **Before ANY sentence that asserts a PR or issue lifecycle state
> (draft / ready / open / merged / approved / closed / in-review / "human gate") —
> whether in a status summary or table, a "your move" line, a mid-loop check-in, an
> aside, a forward plan, OR the answer to a direct question — no exceptions, you
> MUST, THIS TURN, run and show the output of:**
> - `gh pr view <n> --json number,state,isDraft,mergedAt,reviewDecision` for
>   **every** PR you are about to mention (both repos — use `--repo` for thrive).
> - `linear issue list --project "<name>" --team BH --all-states --all-assignees
>   --sort manual` for the project.
>
> **The status you report must be transcribed from *that* output, run this turn —
> not from your ledger, not from what an executor returned, not from what you said
> last turn.** If you have not run these calls this turn, you may not write the
> words draft / ready / open / merged / closed / in-review / "human gate" at all.
> The freshly-fetched values ARE the report; the ledger only tells you which PRs to
> re-fetch.

**Park-and-continue:** the loop halts when **no ready issue remains** AND **no open
stack still needs watching**. While stacked PRs are open with unmerged parents, stay
in a low-frequency maintenance watch (step 6) — the human merges async, so catch
each merge and rebase the descendants. The loop is safe to kill and re-invoke;
re-derivation (step 1) detects any rebase missed while it was down. Report a
summary — **built from the step-7 re-fetch, not the ledger** — of: shipped/merged
PRs, parked issues + blockers, stacks awaiting merge, and any rebases done or
parked-on-conflict.

## Concurrency notes

- Screenshots are intentionally **not** taken (see `ship-issue`), so
  executors need edit + lint + typecheck + test + git/gh/linear — **not** N running
  metro servers. Parallelism is cheap.
- Still respect the cap: more PRs in the human's queue than they can merge just
  piles up stacks waiting on the merge gate.

## Red Flags — STOP

- About to grab an issue outside the launch scope → don't roam.
- About to grab a `ready-for-human` / `needs-info` issue → off-limits.
- About to dispatch two executors against the **same** issue → claim via `Started`
  first; re-derive if unsure.
- About to retry a parked issue automatically → parks are human business; move on.
- About to merge, or push to `main`, or un-draft a PR → that's the human gate.
- About to author or re-scope issues → that's the planning gate, not this loop.
- About to fetch review comments, evaluate findings, or draft/post a reply
  **yourself** → STOP. Review handling is delegated to a subagent; you only
  dispatch, gate, and relay.
- About to write a status word (draft/ready/open/merged/closed/in-review/approved/"human
  gate") without having run `gh pr view` + `linear issue list` **this turn** → STOP,
  fetch first (step-7 gate). This includes asserting a PR's state **while answering a
  question** or in an aside — not only in a formal status block. The ledger is stale
  the instant the human acts.
- About to report a loop PR as "waiting" / "batching" while it has an **unresolved
  review thread** → STOP; dispatch the review handler this turn. Feedback existing is
  the trigger, not the bot round finishing.
- About to `git rebase main` (plain) on a stacked child after its parent merged →
  use `git rebase --onto main <old-base> <child>`; a plain rebase re-applies the
  squashed parent's commits and conflicts.
- About to `git push --force` → use `--force-with-lease`, and only ever on the
  loop's own stacked branches — never anything the human owns.

## Related Skills (composed; degrade gracefully if absent)

- `ship-issue` — the per-issue unit this dispatches.
- `orchestrating-linear-work` — contract-shaped decomposition + lock-in
  propagation this builds on.
- `dispatching-parallel-agents` — fan-out pattern.
- `linear-cli` — Linear commands, states, projects.

## Later graduations (out of scope now)

- Detached / scheduled mode (`/schedule`) once trusted, with Teams notifications
  for parks.
- Concurrency beyond the cap.

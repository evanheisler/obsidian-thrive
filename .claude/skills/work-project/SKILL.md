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

## 🛑 The uncertainty gate — read before anything else

**The instant your reasoning reaches any of these, you STOP and bring it to the human.
No artifact. No exceptions.**

- "this can't be fixed in this PR"
- "this needs its own ticket" / "deserves a follow-up"
- "this is out of scope but real"
- "the routing/scope decision isn't mine"
- "I don't know how to proceed here"

Those sentences are the **highest-risk moment in the whole loop**, not a routine
handoff. What comes out of them is a scope commitment on the human's project, and the
loop publishes under **his account** — so an issue you author reads as him queueing
work, and a comment you write reads as him deciding. Both look settled to every
teammate and bot who sees them.

**None of these is yours to start on your own**, and that includes subagents:
`linear issue create`, wiring issue relations, claiming an issue, dispatching an
executor for it, opening a follow-up branch, or posting/editing any PR or Linear prose
that names the problem.

**Do this instead:** raise it in session — what is broken, how far it reaches, one
question — and stop. He decides whether it becomes a ticket, rides an existing PR, or
gets dropped. His "add a ticket for X" authorizes *that ticket only*, never staffing
it.

**A backstop exists, and it is a checkpoint, not a wall.** A `PreToolUse` hook turns
`linear issue create`, and any PR/Linear body that defers a decision or tags someone,
into a **permission prompt** carrying the reason. When he has authorized the action,
approve it and carry on — that is the hook working. When the prompt appears and you
have *not* asked him, it caught you acting unilaterally: cancel, end the turn, and
raise the finding. The prompt is never something to reword your way past.

**Everything published carries his authority.** PR and Linear prose states findings,
mechanisms, and settled decisions in the first person. It never asks a question, never
tags anyone, never says a call isn't yours to make — his account cannot ask itself to
decide.

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
- `gh stack` is installed (`gh extension install github/gh-stack`) — it is a `gh`
  extension, not core. Without it the loop can still branch-chain, but has no stack
  registration and no `unstack` abort (steps 4 and 6).

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
- **GitHub** — open draft PRs and remote branches for issues in scope, plus **stack
  membership**: `gh api repos/<owner>/<repo>/stacks --jq '.[] | select(.open)'`
  enumerates open stacks with their PRs bottom-to-top; one PR's slot comes from
  `gh api repos/<owner>/<repo>/pulls/<n> --jq .stack`. Flag any open stacked PR whose
  **parent has already merged** — GitHub restacks the next child itself, so that is a
  verification, not a rebase (step 6).
- **Feedback on every open loop PR — all three surfaces** (see "What counts as
  feedback"). Counting unresolved review threads alone is a **false negative**, not a
  shortcut.

**Orphan rule:** an issue in `Started` with **no draft PR and no remote branch** =
a crashed executor's leftover → reset to `Todo`/`ready-for-agent` and re-dispatch
into a fresh worktree (safe — nothing landed). `Started` **with** a draft PR =
in-review, leave it.

**Arm the feedback watch before leaving step 1.** Re-derive is a one-shot snapshot;
it is not polling. Nothing between turns is seen unless a watch is running, so start
a persistent background monitor over the in-scope PRs covering all three surfaces
plus merges, and keep it alive for the loop. Re-arm it on every restart. A loop with
no armed watch is blind between turns — that is a dropped review waiting to happen,
not a stylistic preference.

### 2. Build the ready set + order

- **Ready** = `ready-for-agent` + `Todo` + every `Blocked by` satisfied (blocker
  merged, **or** its branch exists so this issue can stack on it).
- **Never grab** `ready-for-human` or `needs-info`.
- **Order** = topological over `Blocked by`; Linear priority as tiebreaker; an
  explicit "deploy after X" / merge-order note overrides both.

### 3. Dispatch the pool

Fill the pool up to the cap with **independent** ready issues. For each, dispatch
an executor subagent with the filled-in [`executor-prompt.md`](./executor-prompt.md).

**Pin every executor to Opus — `model: "opus"` on the dispatch.** Subagents inherit
the main-loop model, so an orchestrator session running Fable fans out *Fable*
executors by default, at Fable's rate, for build work Opus does well. The pin is what
keeps the expensive model on orchestration and the cheaper one on execution; it costs
nothing when the orchestrator is already Opus.

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
- When B is `Blocked by` A and A's PR is open-but-unmerged, dispatch B to **branch
  off A's branch** (PR targets A's branch). Pass the base branch in the prompt.
- **Once B's PR exists, register the stack on GitHub** — arguments run bottom to top:
  ```
  gh stack link <A-pr> <B-pr>
  ```
  Use **`link`, never `init` / `add` / `submit`**: those assume one locally-tracked
  working tree, and every executor has its own `nwt` worktree. `link` needs no local
  tracking, creates the stack when none exists, extends it when A is already in one,
  and never removes a PR.
- Stacking is for **true `Blocked by` chains only**. **Stack-depth cap ~3** — past
  that, park the next link and surface, rather than build a rebase nightmare.
- **Record each stacked child's parent branch + base tip in the ledger** when you
  link. GitHub's auto-restack makes that ref unnecessary on the happy path; it is what
  the **abort** path needs (step 6), and an abort is the worst moment to be
  reconstructing a deleted ref.

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

Bot and human review **will** land on open loop PRs. When it does, the orchestrator
**dispatches a subagent that runs `receiving-code-review` — it never fetches,
evaluates, fixes, or replies inline.** Pin it to Opus the same way (`model: "opus"`).
Hand the subagent the PR number + worktree; it
evaluates each finding, fixes what needs fixing in the worktree, re-runs preflight,
pushes, replies in-thread (`Addressed in <sha>`) or pushes back with a technical
reason, resolves the addressed threads, and returns a **one-paragraph** summary.

#### Future work and decisions come back here — never into the PR

**Future work appears in published text ONLY as a link to a Linear issue the human
approved.** The test is mechanical, so put it in every dispatch prompt verbatim:

> If you cannot paste a `https://linear.app/...` URL for an issue the human approved,
> the sentence does not go in the PR.

No link → cut it. "Worth its own ticket", "belongs in a separate PR", "flagged for a
follow-up", "out of scope here", and citing a cost to justify not doing something are
all the same violation, and so is naming a ticket without fetching it in the same
turn to confirm it exists. This catches what the decision rule below misses: an agent
reads "flagging a follow-up" as recording a fact, not making a decision, so a ban on
*decisions* sails past it. **Check returned work for it — it recurred three times in
one session with the decision rule already in the prompt.** Work with no approved
ticket is either a ticket the human authors or it does not exist; a line in review
prose is neither.


GitHub and Linear record what was *done* and why. They are not the human's inbox,
and nobody mines review prose for action items. So **anything that is the human's
to decide — a design call, a scope question, a risk they carry, an "out of scope,
needs its own ticket" — travels in the handler's return, and you raise it in the
session.** Say so in every dispatch prompt.

Tagging the human is the worst version and is banned outright: the loop posts *as*
their account, so "flagged for @x" / "left for @x" is the account summoning itself.
But an **untagged** decision buried in a review body is the same failure — the item
is parked on a surface no one reads for action. Findings go in the PR stated
neutrally, with no name and no ask; decisions go in the return.

#### What counts as feedback — three surfaces, not one

Feedback lives on **three independent GitHub surfaces**. A review submitted with a
body and **zero inline comments creates zero review threads**, so a thread count
returns `0` while an 8000-character human review sits unread. Check all three, every
cycle, per PR:

```
gh api repos/<owner>/<repo>/pulls/<n>/reviews   --jq '.[] | select((.body|length) > 0) | {user: .user.login, state, submitted_at, len: (.body|length)}'
gh api repos/<owner>/<repo>/issues/<n>/comments --jq '.[] | {user: .user.login, created_at, len: (.body|length)}'
gh api graphql -f query='...pullRequest(number: <n>){reviewThreads(first:100){nodes{isResolved comments(first:1){nodes{createdAt author{login} path}}}}}'
```

- **Review bodies** — `state` is `COMMENTED` / `CHANGES_REQUESTED` / `APPROVED`. Body-only
  reviews are invisible to `reviewThreads`. **This is the surface that gets missed.**
- **Issue comments** — bot summaries and human follow-ups. Filter out `vercel` /
  `linear` / `github-actions` noise; everything else is real.
- **Inline review threads** — the only surface with a resolve state.

Only threads can be *resolved*, so "unresolved" is not a usable completeness test for
the other two. For bodies and comments, handled = a reply exists that post-dates them.
When in doubt whether an older review was ever addressed, dispatch a handler to verify
against the current tree rather than assuming it was — a body from days ago sitting
unanswered looks identical to one that was handled silently.

Re-polling (reading PR state) stays with you; the *handling* does not. You read the
summary, update the ledger, and relay — you do **not** ingest the individual findings.
**NEVER re-fire the bot — never toggle the `claude-review` label after a PR's
initial review. (`codex-review` is dead — never add it; Codex fires on its own
when the human opens the PR.) The bot reviews a PR ONCE; addressing a finding is
push + reply in-thread, and CI re-runs on push on its own. Re-firing on each push
burns tokens + CI minutes (one PR hit 8 bot runs this way).** The only human gate is still
**merge** (the loop never un-drafts or merges).

**Active, never batched.** The trigger to dispatch the handler is *unhandled feedback
exists on an open loop PR* — on **any of the three surfaces** — not *the bot round
finished*. The moment a watch event or a re-derive surfaces one, dispatch the handler
for that PR **that turn**. Do not wait for a monitor to report "terminal," do not
batch across rounds, and **never report a PR as "clean" / "waiting on review" /
"batching" while it carries unhandled feedback** — feedback parked on a monitor is a
dropped review, the exact failure this loop exists to prevent.

**Report what you measured, not what you queried.** "0 unresolved threads" is a fact
about one surface; "no feedback" is a claim about three. Never let the first become
the second. If you have not checked review bodies and issue comments this turn, you
may not call a PR clean — say which surface you checked.

| Rationalization | Reality |
|---|---|
| "It's only a couple findings — faster to fix them here." | Those findings become the whole review detail in your context; that bloat is exactly what this prevents. Dispatch. |
| "I have to evaluate the findings before I can delegate." | The subagent runs `receiving-code-review`. Evaluation IS the delegated work, not a prerequisite you do first. |
| "The fix is done, I'll just post the replies myself." | Fetch + draft + post is the review loop; it goes to the subagent. |
| "I'll batch these threads once the whole round is terminal." | Feedback *existing* is the trigger, not round-completion. Feedback waiting on a monitor is a dropped review — dispatch now. |
| "`unresolved=0`, so that PR is clean." | You measured one surface of three. A body-only review creates no thread and returns `0`. Check reviews + comments before saying clean. |
| "I re-derived at the start of the turn, so I'm current." | Re-derive is a snapshot. Feedback landing between turns is invisible without an armed watch. Arm it in step 1. |
| "That review body is from days ago — it must have been handled." | Bodies carry no resolve state, so old and unhandled looks exactly like old and handled. Dispatch a handler to verify against the tree. |

### 6. Stack maintenance — verify GitHub's restack, abort if it goes wrong

We **squash-merge**, and stacks support it: each PR lands as one squashed commit,
bottom-up. When the human merges a stacked PR's parent, **GitHub rebases the next
unmerged PR onto the stack base itself.** Replaying children by hand is no longer the
happy path — verifying the restack is.

**When:** every re-derive (step 1) and every merge event from the armed watch.

**Verify, never assume** — after a parent merges, per remaining child:

1. Re-read the stack (`gh api repos/<owner>/<repo>/stacks/<n>`): the merged PR is
   gone and the next child now sits at the bottom on the stack base.
2. Confirm the PR retargeted: `gh pr view <child> --json baseRefName`.
3. **Re-run preflight in that child's worktree** — a restack onto a moved `main` can
   break the build. Green → done. Red, stale, or conflicted → abort.

**Abort → fall back to manual stack management.** This is the escape hatch, and it is
lossless:

```
gh stack unstack <stack-number>
```

It drops the stack grouping on GitHub and **leaves every PR's base branch untouched**
— the PRs stay exactly as this loop created them, each chained on its parent's
branch. The pre-stacks procedure then applies unchanged, in the child's worktree
(`cd "$WT" &&`):

1. Replay only the child's own commits. **Use `--onto`** to drop the parent's
   now-squashed commits — never a plain `git rebase main`, which re-applies them and
   conflicts:
   ```
   git rebase --onto main <recorded-base-tip> <child-branch>
   ```
   (Mid-stack child: onto the parent's *rebased* tip, not `main`.)
2. **Re-run preflight.** Green → continue; red → **park** (never force-push broken
   history).
3. `git push --force-with-lease` — never plain `--force`.
4. Confirm the PR base (`gh pr edit <child> --base main`, or the parent's branch for a
   mid-stack child).
5. **Cascade top-down** — the rebase rewrote this child's history, so each descendant
   rebases onto the new tip in turn.

**Conflict → park the child and everything below it.** `git rebase --abort`, leave
the branch untouched, and park with a note naming the parent that moved. Conflict
resolution is a human judgment call.

**`unstack` is not guaranteed total.** GitHub refuses to unstack PRs that are queued
for merge or have auto-merge enabled, and keeps the stack alive when any member stays.
Read the command's output instead of assuming the abort landed.

**Merge is still the human's gate, and stacks change its shape** — relay this, never
do it:

- `gh stack merge` is atomic and bottom-up: everything below the chosen PR merges
  with it, all-or-nothing. **A mid-stack PR cannot merge alone.**
- **Auto-merge is unsupported** on stacked PRs.
- If `main` gains a merge queue, the queue picks the merge method and any
  merge-method flag is ignored with a warning.

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
- About to dispatch an executor or review handler **without `model: "opus"`** → STOP.
  Unpinned subagents inherit the orchestrator's model.
- About to retry a parked issue automatically → parks are human business; move on.
- About to merge, or push to `main`, or un-draft a PR → that's the human gate.
- About to author or re-scope issues → that's the planning gate, not this loop.
- About to let a decision, action item, ask, **or any mention of future work** ship
  inside a PR body, review, thread, or Linear comment — yours or a subagent's →
  STOP. It comes back in the return and is raised in the session. "Worth its own
  ticket" / "belongs in a separate PR" / "flagged for a follow-up" count; the
  note-not-decision framing is how they slip through. `@`-tagging the human is the
  same failure with a siren on it; the loop posts as their account.
- About to fetch review comments, evaluate findings, or draft/post a reply
  **yourself** → STOP. Review handling is delegated to a subagent; you only
  dispatch, gate, and relay.
- About to write a status word (draft/ready/open/merged/closed/in-review/approved/"human
  gate") without having run `gh pr view` + `linear issue list` **this turn** → STOP,
  fetch first (step-7 gate). This includes asserting a PR's state **while answering a
  question** or in an aside — not only in a formal status block. The ledger is stale
  the instant the human acts.
- About to report a loop PR as "clean" / "waiting" / "batching" while it carries
  **unhandled feedback on any of the three surfaces** → STOP; dispatch the review
  handler this turn. Feedback existing is the trigger, not the bot round finishing.
- About to call a PR clean off an **unresolved-thread count alone** → STOP. That
  measures one surface of three; a body-only review returns `0`. Check
  `pulls/<n>/reviews` and `issues/<n>/comments` before the word "clean".
- About to run the loop with **no armed feedback watch** → STOP, arm it (step 1).
  Re-derive is a snapshot; between turns you are blind without a monitor.
- About to hand-rebase a stacked child right after its parent merged → STOP; GitHub
  restacks the next child itself. Verify first (step 6). Hand-rebasing is the **abort**
  path and only runs after `gh stack unstack`.
- About to `git rebase main` (plain) on a stacked child during an abort →
  use `git rebase --onto main <old-base> <child>`; a plain rebase re-applies the
  squashed parent's commits and conflicts.
- About to run `gh stack init` / `add` / `submit` → STOP. Those assume one
  locally-tracked working tree and the loop has one worktree per executor. Stack
  membership is `gh stack link <parent-pr> <child-pr>`, run from here.
- About to run `gh stack merge` → that's the merge gate; the loop never merges.
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

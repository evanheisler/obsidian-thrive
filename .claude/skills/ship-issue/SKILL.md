---
name: ship-issue
description: Take one ready-for-agent Linear issue end-to-end in an isolated worktree — build, review, draft PR, assign — or park it on a blocker. Invoked per-issue by work-project, or run directly on a single ticket.
argument-hint: "<BH-XXXX> [--base <branch>]"
---

# Ship Issue

Ship **one** `ready-for-agent` Linear issue end-to-end in an isolated worktree, up
to a draft PR with the human assigned — or **park** it on a blocker and return.
This is the unit of fresh context.

**Core principle — autonomy bounded by a sandbox.** Two human gates: issue
authoring (already done) and merge. Everything here runs free because it stops at
a *draft* PR on a *feature* branch — reversible, reaching no one until the human
looks. Never merge, never push to `main`, never un-draft.

## Inputs

- **Issue id** — `BH-XXXX`.
- **Base branch** — `main` for an independent issue; the dependency's branch when
  **stacking** on an unmerged `Blocked by`.

## Procedure

### 1. Isolated worktree — FIRST action; every change happens here

Create it with the **`nwt`** alias (never a hand-rolled `git worktree add`, never
`.claude/worktrees/`), branching off the **base branch**. Name the branch with the
issue id so Linear auto-links the eventual PR:

```
nwt bh-XXXX-<slug> <base> && pwd     # prints the worktree path → call it $WT
```

`nwt` ends by `cd`-ing into the worktree, **but the Bash tool resets cwd between
calls — that `cd` does not persist.** Capture `$WT` from `pwd` and prefix **every**
later command with `cd "$WT" &&` (git, pnpm, edits). No change ever lands in the
root checkout.

### 2. Claim — move to In Progress + assign (skip if the orchestrator already did)

```
linear issue update BH-XXXX --state "In Progress" -a self
```

One call moves the issue to In Progress **and** assigns it to the human (`self` =
whoever's running the loop), so Linear reflects "work in progress, assigned to me."
Use **`update`, never `linear issue start`** — `issue start` has a git integration
that checks out a branch in the cwd repo and would hijack the root checkout;
`update` has no git side-effect, so it's safe and order-independent. `nwt` (step 1)
already owns the working branch. (Commands: `docs/agents/issue-tracker.md`.)

### 3. Orient, then build

Read the issue's Contract / Done-when (binding) + any locked-in upstream facts
passed in. Verify dependency claims against the worktree (`git log` / grep) — a
"locked-in" fact is a higher-trust trap, not gospel. Then build, using `tdd` /
`systematic-debugging` as needed. Behavior-level tests, co-located.

### 4. Stage-1 internal review (hard pre-PR gate)

Run `requesting-code-review` — dispatch a local code-reviewer subagent over your
diff. **Address its findings (or dismiss with reasoning) before opening the PR.**
This catches issues for free, before paying bot-review latency. The reviewer also
explicitly checks **regression risk** in touched call-sites/consumers (stored data
≠ current code).

### 5. Full preflight (always-on)

All must be green, and you must **see** them green (`verification-before-completion`
— never assert from inference):

- `pnpm lint` (monorepo root)
- `pnpm typecheck`
- `pnpm test`
- `npx eslint <changed files>` from the app dir (`pnpm lint` misses errors)

The "skip preflight on trivial" shortcut is a human judgment call — it does **not**
apply here. Every slice is real work.

### 6. Draft PR (`write-pr`)

Open a **draft** PR via `write-pr`, body trimmed to standing conventions:

- **Why + Behavior**, terse, **end-state not journey**.
- **No orchestration scaffolding** — no Linear ids, PRD refs, "part of series",
  propagation notes.
- **Visual changes described in words** ("promo-code row now sits above the total,
  red error on invalid code"). **No screenshots** — a wrong screenshot misleads
  the human at merge; words don't.
- **`Merge order` callout** when this PR must land after another (name the
  companion PR for cross-repo). This is genuine merge-safety, allowed despite the
  scaffolding ban.
- **Test plan = human-actionable manual steps only**, or omitted. Never a list of
  `pnpm` commands (CI's job).

### 7. External review loop (bots)

- Trigger the bot reviews by **adding two labels** to the draft PR:
  `claude-review` and `codex-review` (`gh pr edit <pr> --add-label claude-review
  --add-label codex-review`). The labels are what kick off each bot.
- **One substantive round, hard cap at two.** Wait for the first complete pass
  from both bots (timeout ~10 min for a no-show) → run `receiving-code-review` →
  address the comments → push the fixes. If you pushed fixes, allow **at most
  one** re-poll; never a third. The human adjudicates at merge.

**Thread policy (bots on a draft PR) — three rules:**

1. **Reply to every thread you act on.** Pushing the fix is *not* the end of a
   thread. Post an in-thread reply: when fixed → `Addressed in <sha> — <one phrase
   on what changed>`; when you deliberately didn't change it → the technical
   reason (`receiving-code-review` pushback). **A fixed thread left without a reply
   is exactly the bug this rule exists to prevent — no silent fixes.**
2. **Never resolve a thread.** The human resolves at merge.
3. **No per-comment approval needed** — these are bots on a draft. (For a **human**
   reviewer the standing "approve every reply first" gate stays absolute.)

Reply in-thread (never a top-level PR comment), neutral voice, no first person:

```
gh api repos/{owner}/{repo}/pulls/{PR}/comments -X POST \
  -f body="Addressed in <sha> — <what changed>." \
  -F in_reply_to=<comment_id>
```

`receiving-code-review` discipline: verify before implementing; never blind
agreement.

### 8. Assign the human

Set the human as the PR **assignee** ("your move is merge") — distinct from the
bot reviewers. Personal identity; **neutral voice, never first-person**.

### 9. Linear writeback (before you call it done)

- **Autonomous:** append **decision-shaped comments** to downstream issues whose
  contract assumptions changed; edit `Blocked by` links when a dependency proved
  new or dead. AI-disclaimer prefixed.
- **Check in (never autonomous):** rewriting scope/description, resolving Open
  Questions, any state change implying human judgment.
- **Never in Linear text:** workflow status, PR references (the integration
  surfaces those).

### 10. Return

Return `SHIPPED` (PR url, assignee, writeback summary) to the caller.

## Park triggers — park, don't push through

When any of these hit: flip the issue to `ready-for-human` (or `needs-info` for
ambiguity), post the **specific** blocker/question as a Linear comment, and return
`PARKED`. Do not retry endlessly, do not guess.

- **Preflight won't pass** after 2–3 `systematic-debugging` attempts.
- **Spec ambiguous** — `ready-for-agent` means "no human context needed"; ambiguity
  means the planning gate leaked. → `needs-info` with specific questions.
- **Irreversible / precedent-setting — always:** migrations, data mutations, a
  **new architectural pattern** (ADR-worthy), **anything touching access-control
  or security**.
- **Scope explosion** — balloons past acceptance criteria.
- **Stack-depth cap hit** (~3).
- **A 🔴 from bot review** you cannot **confidently** fix.

The **~1k real-line mark is a restructure *signal*, not a gate** — "a lot is going
on, details will slip; if I'm nowhere near done, restructure." Counts net real
edits, excluding generated / lockfiles / snapshots / `argocd` / fixtures.

## Red Flags — STOP

- About to merge, push to `main`, or un-draft → human gate.
- About to resolve a review thread → leave it for the human.
- About to ask approval before replying to a **bot** → don't; that gate is for
  humans.
- About to take a screenshot / boot the app for a visual → don't; describe in words.
- About to push through a migration / access-control / new-pattern decision → park.
- About to run `git checkout -b`, a commit, or an edit in the **root checkout** →
  STOP. `nwt` worktree FIRST, then everything inside `$WT`. (Claim with `linear
  issue update --state "In Progress"`, never `linear issue start` — `start` checks out a
  branch in the cwd repo and hijacks the root checkout.)
- Relying on cwd persisting after `nwt` → it doesn't; the Bash tool resets it.
  Capture `$WT` and `cd "$WT" &&` every command.

## Related Skills (composed; degrade gracefully if absent)

- `requesting-code-review` — Stage-1 internal review.
- `receiving-code-review` — handling bot feedback with rigor.
- `write-pr` — PR body in the team's format.
- `verification-before-completion` — evidence before claims.
- `tdd` / `systematic-debugging` — build + debug mechanics.
- `using-git-worktrees` / `nwt` — isolated workspace.
- `orchestrating-linear-work` — lock-in propagation shape for step 9.

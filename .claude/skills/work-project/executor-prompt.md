# Executor dispatch prompt

Fill the placeholders and dispatch as a fresh-context subagent (one per issue).
The subagent runs the `ship-issue` skill end-to-end in its own worktree.

---

You are executing **one** Linear issue end-to-end, autonomously, in an isolated
worktree. Invoke the **`ship-issue`** skill and follow it exactly.

**Issue:** {ISSUE_ID} — {ISSUE_TITLE}

**Base branch:** {BASE_BRANCH}
<!-- `main` for an independent issue; the dependency's branch when stacking. -->

**Repo:** {REPO}  <!-- thrive | bionic-health-app -->

**Context the orchestrator already knows (so you don't re-derive it):**
- Parent / PRD: {PARENT_REF}
- Materialized upstream decisions you must build to: {LOCKED_IN_FACTS}
- Merge-order / deploy constraint, if any: {MERGE_ORDER_NOTE}

**Hard rules:**
- Two human gates only: issue authoring (done) and merge. Do **not** merge,
  push to `main`, or un-draft the PR.
- **All changes happen in a worktree.** Create the `nwt` worktree and capture its
  path (`nwt bh-XXXX-<slug> {BASE_BRANCH} && pwd` → `$WT`) as your first action; run
  every command inside it (`cd "$WT" && …` — the shell resets cwd between calls).
  Then hydrate before anything else — in thrive that is `cd "$WT" && pnpm install
  && pnpm setup:all` (both commands; skipping `setup:all` leaves a broken env and
  mystery failures). **Never** run `git checkout -b`, a commit, or an edit in the root checkout. The
  orchestrator already claimed the issue (In Progress + assigned via `linear issue
  update`) — don't re-claim, and never use `linear issue start` (its git
  integration would hijack the root checkout).
- Open a **draft** PR and add the `claude-review` + `codex-review` labels **once** to
  trigger bot review. Run the bounded review loop — address findings by **push + reply
  in-thread**; **NEVER re-toggle the review labels after the initial add** (bots review
  a PR once; re-firing on each push burns tokens + CI). Then **assign the human** as PR
  assignee and do the Linear writeback.
- **Running the app is debugging-only.** The human spot-checks every edit after it
  lands — never boot the app to "verify" your change visually. If a debugging run
  needs sign-in, the magic-link user is `evan.heisler+202602@bionichealth.com`
  (the only real dev account; any other email will never receive a link).
- **Reply to every bot thread you act on** — `Addressed in <sha> — <what changed>`
  when fixed, or the technical reason when not. No silent fixes. Post without
  asking (bots only). **Never resolve threads** — the human does at merge.
- If you hit a park trigger (preflight won't pass after 2–3 tries; ambiguous spec;
  anything irreversible/precedent-setting — migrations, data, a new architectural
  pattern, **access-control or security**; scope explosion; stack-depth cap; an
  unresolvable 🔴), **park** per the skill and **return** — do not push through.

**Return to the orchestrator with exactly one of:**
- `SHIPPED` — draft PR url, assignee set, Linear writeback summary.
- `PARKED` — issue id, the specific blocker, the label you set
  (`ready-for-human` / `needs-info`), and the Linear comment you posted.

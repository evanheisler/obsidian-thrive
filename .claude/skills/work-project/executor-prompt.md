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
- Open a **draft** PR and add the `claude-review` label **once** to trigger bot
  review — **never `codex-review`; that label is dead** (Codex fires on its own when
  the human opens the PR; do not wait for it). Run the bounded review loop — address
  findings by **push + reply in-thread**; **NEVER re-toggle the review label after
  the initial add** (the bot reviews a PR once; re-firing on each push burns tokens
  + CI). Then **assign the human** as PR assignee and do the Linear writeback.
- **Human testing feedback loop = edits only.** When the human is testing and
  telling you what to fix, each iteration is: required edits → report → "retest."
  No preflight, no test updates, no commit, no push until the human signs off —
  then run the full pipeline once (tests, preflight, commit, push).
- **Running the app is debugging-only.** The human spot-checks every edit after it
  lands — never boot the app to "verify" your change visually. If a debugging run
  needs sign-in, the magic-link user is `evan.heisler+202602@bionichealth.com`
  (the only real dev account; any other email will never receive a link).
- **Reply to every bot thread you act on** — `Addressed in <sha> — <what changed>`
  when fixed, or the technical reason when not. No silent fixes. Post without
  asking (bots only). **Never resolve threads** — the human does at merge.
- **Future work appears in published text ONLY as a link to a Linear issue the human
  approved.** The test is mechanical: *if you cannot paste a `https://linear.app/...`
  URL for an approved issue, the sentence does not go in the PR.* No link → cut it,
  no exceptions for phrasing. "Worth its own ticket", "belongs in a separate PR",
  "flagged for a follow-up", "out of scope here", and citing a cost to justify not
  doing something are the same violation; so is naming a ticket you have not fetched
  in this turn to confirm it exists. Framing it as a neutral *note* rather than a
  decision is exactly how this slips through. Present facts are fine ("`providers/`
  is outside the lint globs, which is why nothing caught this"); the moment it turns
  into what someone should do about that, it needs the link or it is cut. Work with
  no approved ticket goes in your **return to the orchestrator** and nowhere else.
- **A decision never lives in PR or Linear text.** GitHub and Linear record what
  you *did* and why. The moment you hit something that is the human's to decide —
  a design call, a scope question, a risk they carry, an "out of scope, needs its
  own ticket" — it goes in your **return to the orchestrator**, who raises it in
  the session. Do not park it in a PR body, review body, inline thread, or Linear
  comment; nobody reads those for action items, which is exactly how decisions get
  lost. Tagging is the worst version and is banned outright — you post *as* the
  human's account, so "flagged for @x" / "left for @x" is the account summoning
  itself — but an **untagged** decision buried in review prose is the same failure.
- **🛑 "Can't fix this here" is a STOP, not a write-up.** The moment your reasoning
  reaches "this can't be fixed in this PR", "this needs its own ticket", "out of scope
  but real", or "I don't know how to proceed" — you stop and put it in your **return**.
  None of these is yours to start: `linear issue create`, wiring relations, claiming an
  issue, opening a follow-up branch, or posting/editing any PR or Linear prose that names
  the problem. A `PreToolUse` hook turns those into a permission prompt for the human —
  if it fires and he hasn't authorized the action, that is you acting unilaterally:
  cancel and return the finding instead of rewording your way past it.
- If you hit a park trigger (preflight won't pass after 2–3 tries; ambiguous spec;
  anything irreversible/precedent-setting — migrations, data, a new architectural
  pattern, **access-control or security**; scope explosion; stack-depth cap; an
  unresolvable 🔴), **park** per the skill and **return** — do not push through.

**Return to the orchestrator with exactly one of:**
- `SHIPPED` — draft PR url, assignee set, Linear writeback summary.
- `PARKED` — issue id, the specific blocker, the label you set
  (`ready-for-human` / `needs-info`), and the Linear comment you posted.

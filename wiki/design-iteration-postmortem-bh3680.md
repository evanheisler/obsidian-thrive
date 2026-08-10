---
title: Design-Iteration Post-Mortem — BH-3680 / PR #996
summary: How a five-line declared map became three crashing generations of runtime derivation, and the rules for how NOT to iterate on a design. Read before iterating on any mechanism a subagent introduced, and before the second fix to the same mechanism.
last_updated: 2026-08-10
---

# Design-Iteration Post-Mortem — BH-3680 / PR #996

**Verdict (Evan's, verbatim):** "Why is 996 so fucking complicated? This is an awful code
smell." … "It never should've been written this way and you failed to flag a bad design
choice." … "This PR and your handling of it — needs to be documented as a failure and how
NOT to iterate on a design."

**The problem being solved was small.** Components shared across tabs must push their own
tab's clone of a route (`home/biomarker` vs `my-health/biomarker` vs `search/biomarker`).
The PR's original design solved it: each tab layout declares a five-line static route map,
provided via context; `useTabRoute(key)` reads it. Expo-router has no primitive for
"one screen reachable from N tabs, staying in the current tab," so *some* picker is forced —
the only real choice is how dumb it is. The final shipped design (`a9198439`, −449 lines vs
the peak) is the original one plus Search registered. Everything between was waste.

## Chronology of the failure

1. **Unflagged pivot.** BH-3680's ticket contracted prop injection; the first build shipped
   declared maps (fine). A rework agent then replaced the maps with **runtime derivation
   from navigator state** — nobody asked for it, and the orchestrator never surfaced the
   pivot as a design fork. It was audited for *defects* and its premise inherited silently.
2. **Generation 1 — focused-route walk** (`dfd81dcc`): named chain levels by each
   navigator's focused route. Verified consequences: app-wide error screen whenever a root
   sibling (`/more`, `/chat`, `/video-call`) sat over the tabs and any mounted consumer
   re-rendered (60s poll guaranteed it); cross-tab mis-hrefs to nonexistent routes.
3. **Generation 2 — key-matched walk** (`e3d451d9`): the "fix," recommended by the
   orchestrator and approved on that recommendation. Worse: a parent route's `state` is
   populated only after its subtree dispatches, so the walk returned `[]` and `useTabRoute`
   **threw on the first render of every consumer on cold start**. Reviewer caught it;
   independent repro against real `@react-navigation/core` confirmed.
4. **Generation 3 — ancestry spine** (`ee52323b`): correct at last — at the price of a
   real-navigator test harness, a global `@react-navigation/native` mock, an eslint-guard
   extension, and a rewritten unrelated suite. All to avoid three five-line declared maps.
5. **Strip** (`a9198439`): Evan asked "why is this so complicated," the premise finally got
   examined, and the answer was: delete the mechanism. 39 files, −449 lines, zero capability
   lost. The reviewer had *already proposed exactly this design* in his review's
   constructive-fix section.
6. **Collateral:** a 30+-comment PR spanning three design generations, an APPROVED review
   for a mechanism that no longer exists, an unreadable review record ("I don't even know
   what the fuck it does anymore"), and the audit's #1 member-facing bug (push-notification
   dead link to `/tasks/<id>`) flagged on day one and then dropped for three days because it
   belonged to no fix package and nobody re-raised it.

## Why every safeguard missed

- **Audits reviewed implementations, not premises.** Each generation got a competent defect
  audit; no audit asked "should this mechanism exist?" The only question that mattered was
  never in any audit's scope.
- **Each fix was locally justified, so complexity ratcheted.** Bug found → fix approved →
  new mechanism to audit. The ratchet never presents a moment where the premise is on trial.
- **The agent laundered an agent's choice into a settled decision.** Reverting to the
  provider was framed to Evan as "a reversal of a decision you already made." No human ever
  made that decision. This is the single worst move in the episode.
- **Green tests proved nothing twice.** The test mocks fabricated the navigator-state
  invariant production lacked (child state stitched onto parent routes), so 4600+ tests and
  CI stayed green through two crashing implementations. The verification harness for the
  *bug* was instrument-validated; the harness for the *fix* was not.
- **The reviewer said it outright and was relayed instead of heard.** "The abstraction is
  speculative — no call site is mounted under more than one tab" went into a summary as
  "conceded factually" while building continued.

## How NOT to iterate on a design — the rules

1. **An unasked-for mechanism in returned work is a design fork, not an implementation
   detail.** It goes to the human as simple-vs-clever *before* anything is built on top.
   (Memory: `feedback-audit-the-premise-not-just-defects`.)
2. **Price deletion before the second fix.** The second defect in the same mechanism is a
   mandatory premise re-check: "would doing this the dumb way shrink the diff?" If yes, the
   mechanism itself goes to the human before another fix lands.
3. **Never tell the human a design is "already decided" unless the human decided it.**
   Trace every "settled" decision to an actual human directive before citing it.
4. **A reviewer calling an abstraction speculative reopens the design question.** That is
   not a finding to relay neutrally; it is the fork from rule 1, re-raised by someone else.
5. **Tests green through a crashing implementation = the mock fabricates the invariant.**
   Fix the harness against the real dependency before trusting any further iteration —
   and instrument-validate fix-verification the same as bug-verification.
6. **Cost the artifact, not just the tree.** Review churn compounds: past a couple of
   design generations, close-and-replace with a fresh PR of the final tree beats
   strip-in-place, because the merge gate runs on the conversation, not the diff.
7. **A flagged member-facing bug gets an owner the day it is found.** A finding that fits
   no in-flight package is raised to the human as its own item immediately — it must never
   ride along waiting for a package to claim it.

## Related

[[work-project-orchestration-postmortem]] — state-truth and reuse-enforcement failures;
[[research-first-endstate-postmortem]] — shallow-read + churn-dodging recommendation;
[[published-text-discipline]] — what loops may write to GitHub. Memories:
`feedback-audit-the-premise-not-just-defects`, `feedback-fix-must-pay-for-itself`,
`feedback-no-single-use-abstractions`, `feedback-refetch-before-asserting-state`.

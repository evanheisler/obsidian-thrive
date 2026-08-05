---
name: feedback-never-tag-evan-in-pr-comments
description: A decision never lives in PR or Linear text — it is surfaced in the session; tagging Evan is the same failure with a siren on it
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 30fe3b2d-927f-4789-8b54-4e06bc1b8fb3
  modified: 2026-08-05T17:04:27.659Z
---

GitHub and Linear record what was **done** and why. They are not Evan's inbox.
Anything that is his to decide — a design call, a scope question, a risk he
carries, an "out of scope, needs its own ticket" — is surfaced **in the session**,
never parked in a PR body, review body, inline thread, or Linear comment.

`@evanheisler` is banned outright on those surfaces: the loop posts *as* his
account, so "flagged for @x" / "left for @x" / "@x adjudicated this" is the account
summoning itself. But the tag is only the loud version — an **untagged** decision
buried in review prose is the same failure, because nobody reads PR text for action
items.

**How to apply:** findings go in the PR stated neutrally, with no name and no ask
attached, and left undecided. Decisions travel in the subagent's return to the
orchestrator and get asked here, one item per turn. Enforced in the dispatch
templates, not just recall: `work-project/SKILL.md` (review-handling section +
Red Flags), `work-project/executor-prompt.md`, and `ship-issue/SKILL.md` (step 7 +
Red Flags). Related: [[feedback-state-the-finding-then-ask]],
[[feedback-action-items-explicit-list]], [[feedback-present-findings-before-acting]],
[[feedback-no-method-narration-to-evan]].

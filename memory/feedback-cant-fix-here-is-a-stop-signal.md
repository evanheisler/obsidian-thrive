---
name: feedback-cant-fix-here-is-a-stop-signal
description: "Can't fix this here" or "not sure how to proceed" means stop and loop Evan in — never publish a comment or issue off that finding
metadata:
  type: feedback
---

Any moment the answer trends toward "I don't know what to do with this", "this can't
be fixed in this PR", "this needs its own ticket", or "the routing decision isn't
mine" is a **stop signal**, not a thing to write up. On PR #993 that moment produced a
published review comment and an authored issue (BH-3743) — both artifacts committing
Evan's project to a direction he never saw.

**Why:** Uncertainty is exactly the point where an artifact does the most damage.
Published under Evan's account, it looks settled to teammates and bots, and it hardens
a scope decision before he has made one. The finding is valuable; the unilateral
disposition of it is the failure.

**How to apply:** On hitting one of those signals — stop. Do not `linear issue create`,
do not post or edit a PR comment, do not open a follow-up branch. Bring it to the
session: what's broken, how far it reaches, one question. Publish only what he
authorizes, and only after. This binds dispatched subagents too — put it in every
executor and review-handler prompt, since they publish under the same account.
Related: [[feedback-never-author-issues-in-the-loop]],
[[feedback-pr-prose-speaks-with-evans-authority]],
[[feedback-present-findings-before-acting]], [[feedback-state-the-finding-then-ask]].

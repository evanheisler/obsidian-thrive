---
name: feedback-issue-text-is-a-starting-point
description: "Issue text is a line item to start work from, easily overridden — repo evidence settles technical questions; escalating to Evan what the code already answers is the failure"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9b312abb-2781-4129-827e-c162a412bb9d
  modified: 2026-08-11T20:19:57.598Z
---

Issue text is **easily overridable** — it is a line item to start work from, not a spec to
defend. When repo evidence (an established pattern, a sibling implementation, a documented
precedent) contradicts a technical line in the issue, the code wins. Decide it and report;
do not escalate the fork to Evan.

**Why:** On PR 1027 the ticket said the cancel latch could stay component-local. The repo
already answered the question — the sibling reschedule latch was deliberately hoisted above
the same remount boundary with a comment naming the exact gap — and two reviewers flagged
it. I still framed "reverse the ticket's line" as Evan's call and parked the fix on him.
Evan, 2026-08-11: *"I have told you numerous times that the issue text is EASILY
OVERRIDEABLE. All it is, is a line item to start work from. It is idiotic to hold the issue
to such a high standard. There was obvious proof from the code how it should've been done,
yet you sided with the fucking project management tool."*

**How to apply:** when issue text and repo evidence disagree on a technical approach, the
test is "does the code already settle this?" — an in-repo precedent solving the identical
problem is a settled answer, not a fork. Fix to match the precedent and report the override
in one line ("ticket said X; repo pattern at file:line says Y; went with Y"). A real fork
(product behavior, risk Evan carries, no in-repo answer) still goes to him — but the ticket
having said something is never what makes it a fork.

Related: [[feedback-ticket-text-is-not-evans-decision]] (deliverable *shape* still gets
surfaced first), [[feedback-figma-node-outranks-blanket-ruling]],
[[feedback-current-shape-is-not-a-requirement]], [[feedback-ask-only-at-a-real-fork]]

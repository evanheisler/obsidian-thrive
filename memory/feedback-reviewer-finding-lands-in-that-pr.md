---
name: feedback-reviewer-finding-lands-in-that-pr
description: "A structural finding raised against an open PR gets fixed in that PR — 'deserves a ticket, not more of this PR' is deferral, and a promised ticket nobody creates is a lie in the review thread"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cc4f3cba-ef5c-4388-8eea-b653a84beaba
  modified: 2026-07-28T22:00:57.702Z
---

On PR #942, jellis18 flagged that the Stream color mapping is authored three times (patient CSS / EHR CSS / native TS) and said it "deserves a ticket, not more of this PR." My executor replied "Agreed on both counts — it's real, and it's a ticket rather than more of this PR." No ticket existed, and I had just recommended cutting the closest tracked equivalent (BH-3626 §3) as refuted. Evan: "SO ARE YOU FUCKING FIXING IT OR NOT. I am sick of dancing around all this crufty code."

That was the **third** time in one session I recommended cutting consolidation scope — §3 (shared theme vars), §4 (platform splits), then the triplication — against a standing directive of "Consolidate code across platforms; only split out WHAT IS NECESSARY."

**Why:** deferring to a ticket reads as ownership but is the opposite — it converts a found, understood, currently-open problem into backlog nobody schedules, while the PR that could have fixed it merges. Worse, the reviewer and Evan both read the reply as a commitment. And each deferral means the same files get rewritten again next week, which is exactly the churn Evan has been eating.

**How to apply:** when a reviewer raises a structural finding against a PR that is still open, the default is fix it in that PR. Deferral needs a real blocker (it would restructure something the PR doesn't touch, or it needs a decision Evan owns) — not "out of scope." Never write "deserves a ticket" into a review thread without creating the ticket in the same action. Before recommending that consolidation work be cut, check whether my objection kills the *goal* or only the *mechanism I happened to imagine*: I concluded a shared theme mapping was impossible because patient's hand-authored CSS uses per-scope values — true of hand-authored sheets, false the moment the sheets are generated. Related: [[feedback-found-bug-gets-fixed-not-filed]], [[feedback-touching-it-makes-it-yours]], [[feedback-dont-dodge-endstate-to-avoid-churn]], [[feedback-proposals-cover-named-surface-only]].

**The counterweight Evan attached, which is part of the rule:** "ONLY IF you don't introduce MORE REGRESSIONS. 942 is relatively stable right now." Folding work into a late-stage PR requires a provable no-change gate — for a refactor of *where* something is authored, extract every (selector, variable, resolved value) triple before and after and require an empty diff, with a park-and-revert if it isn't empty. "I believe the new value is better" during a pure refactor is the regression, not the improvement.

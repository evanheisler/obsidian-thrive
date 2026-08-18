---
name: feedback-close-the-review-loop-to-rerequest
description: "Every review on a loop PR gets a visible response (fix or reasoned no-change), then tell Evan the PR is ready to re-request review — silent evaluation is not handling"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 1fbc0aee-e6be-4ab1-8c5f-940e66c9159f
  modified: 2026-08-18T13:55:53.812Z
---

2026-08-18, releases-as-deploy-artifacts: handlers evaluated three bot review bodies as
"settled, no relitigation" and published nothing. Evan: "Every one of your PRs HAS COMMENTS
ON THEM that you have not responded to… I expect you to address the feedback in comments
(not only inline comments) and tell me when a PR is ready to re-request review… either make
corrections or respond with why no changes are being made and then tell me to re-request
review."

**Why:** A reviewed-but-unapproved PR is parked until the author visibly closes the loop.
An internal verdict of "already documented" is invisible to reviewers; the PR reads as
ignoring its review. Review bodies have no reply mechanism and top-level comments are
hook-blocked, so the visible response is an inline comment anchored to the relevant line.
Related: [[feedback-loop-posts-human-review-replies]], [[feedback-resolve-addressed-threads]].

**How to apply:** For every review on a loop PR — body-only bot reviews included — either
push a fix or post the reasoned no-change response on the PR, then report to Evan that the
PR is ready to re-request review. "Handled" = a visible response post-dates the review AND
Evan has been told it's re-reviewable. A handler return of "nothing to do" without a
published response does not close the loop.

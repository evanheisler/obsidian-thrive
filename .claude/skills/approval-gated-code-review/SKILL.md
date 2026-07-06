---
name: approval-gated-code-review
description: Use when handling PR review feedback for Evan, including fetching comments, addressing review threads, drafting replies, or preparing reviewed changes for commit and push
---

# Approval-Gated Code Review

## Overview

This extends `receiving-code-review` for Evan's PR feedback workflow.

**Core principle:** local fixes and verification are allowed; publication is approval-gated.

## Required Sub-Skill

Before using this skill, load and follow `receiving-code-review`. Evaluate feedback technically; do not blindly implement low-value or incorrect suggestions.

## Workflow

1. Fetch the PR's top-level comments, reviews, and inline review threads.
2. Restate the actionable feedback and evaluate the value of each change.
3. Address only what needs fixing locally.
4. Run verification.
5. **STOP before committing.** Show Evan:
   - changed files
   - verification results
   - proposed commit message
   - feedback items fixed, deferred, or pushed back on

   This checkpoint authorizes the commit **and** its push to the PR branch as one unit — replies cite the commit SHA, and a commit addressing review feedback is meaningless until it is on the remote.
6. Wait for Evan to explicitly approve committing.
7. Commit the approved changes, then **immediately push** to the PR branch. Confirm the push succeeded before doing anything else.
8. Draft exact GitHub inline replies and thread resolutions.
9. **STOP again.** Wait for Evan to explicitly approve the reply/resolution text.
10. Post the approved comments and resolutions using `gh`. The commit is already on the remote, so replies safely cite its SHA.
11. **End with the PR's URL** so Evan can open it without hunting for the link.

**Ordering invariant — push before posting.** Never post a reply, resolve a thread, or publish a status that references a commit until that commit is confirmed on the remote. Push is not a trailing step after posting; it happens in step 7, before any reply is drafted.

## Approval Rules

Approval must be explicit. Phrases like "address comments", "handle review", "once approved push", "ready to push", or "fix and resolve" are not approval.

Do not do any of these before the relevant approval checkpoint:

- create a commit
- push or force-push
- post, edit, resolve, or reopen GitHub comments or review threads
- publish status updates that imply GitHub has been handled

If you cross the gate, stop immediately and report only current state and recovery options.

## GitHub Fetch Reference

Use `gh pr view` for top-level PR state and GraphQL for inline threads:

```bash
gh pr view --json number,comments,reviews,latestReviews,reviewDecision,url
gh api graphql -f query='query { repository(owner: "OWNER", name: "REPO") { pullRequest(number: PR) { reviewThreads(first: 100) { nodes { id isResolved isOutdated path line comments(first: 20) { nodes { id databaseId author { login } body url } } } } } } }'
```

## Common Mistakes

| Mistake | Correct Behavior |
| --- | --- |
| Treating "once approved" as approval | Stop and wait for the explicit approval message |
| Replying to threads after local fixes | Draft reply text only; wait for approval |
| Resolving outdated threads automatically | Include proposed resolutions in the approval checkpoint |
| Committing because tests pass | Tests passing triggers the stop-and-review checkpoint |
| Adding extra low-value cleanup | Report it as optional unless Evan approved the scope |
| Posting a reply that cites an unpushed commit | Push in step 7; only post replies/resolutions after the push is confirmed |
| Treating push as a final step after posting | Push immediately after the commit, before drafting any reply |

## Baseline Failure This Prevents

An agent fetched review comments, implemented fixes, committed, pushed, replied to threads, and resolved them before Evan reviewed the changes. This skill exists to prevent that exact workflow failure.

A second failure: after approval, the agent posted a reply citing the commit SHA and resolved threads while the commit was still local, then pushed last. The reply pointed at a commit that did not exist on the remote. The ordering invariant (push in step 7, before posting) prevents this.

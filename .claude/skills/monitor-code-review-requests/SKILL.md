---
name: monitor-code-review-requests
description: Use when reviewing two or more pull requests Evan has been requested on as a reviewer (review requests, open PRs awaiting his review, "review my PRs", "do my review queue", monitoring the review queue), or any time multiple PR reviews would otherwise be handled in one batch.
---

# Monitor Code Review Requests

## Overview

Work the PRs Evan is requested on **one at a time**: run a full `code-review-excellence` review on the PR, present it, propose comments, hard stop, wait for his decision — then the next PR.

**Core principle:** This skill does NOT review code itself. It runs `code-review-excellence` on each PR and wraps it in a serial, gated loop with two overrides. Two things wreck the output, and this skill exists to prevent both:

- **Freelancing** — substituting your own ad-hoc review instead of actually invoking `code-review-excellence`. The method and the format are the sub-skill's; you do not have your own.
- **Batching** — reviewing several PRs in one pass and collapsing them into ranked bullets and a cross-PR summary.

This is the **reviewer** direction (Evan reviewing others' code). Do not confuse it with `approval-gated-code-review`, the **author** direction (Evan receiving feedback on his own PR).

## Run code-review-excellence — actually invoke it

For each PR, you **MUST invoke the Skill tool with `code-review-excellence`.** Do not paraphrase it from memory. Do not substitute your own review. Use its full **method and format**, with the two overrides below.

You did not run it unless your review reflects its method. **Proof you actually ran it** — every PR review must show:

- **CI / test status** checked (`gh pr checks`) — are tests green?
- **PR size** flagged when large (>400 lines → say so).
- **Every dimension swept**, not just the one thread you found interesting: logic & edge cases; **security / authz / PHI / PII** (these are healthcare / FHIR apps — never skip this); performance; test quality & coverage; error handling; maintainability.

If your write-up doesn't show these, you freelanced — stop and actually invoke the skill. (This checklist is how you *verify* you ran the sub-skill; it is not a substitute for invoking it.)

## The Two Overrides

`code-review-excellence` runs as-is **except**:

1. **No praise.** Drop its Strengths section, 🎉 praise labels, and the sandwich method entirely. Never draft a praise comment. Comments exist only for things worth commenting on.
2. **Inline only.** Every comment you draft or post is an inline review comment anchored to a `file:line`. Never a top-level / PR-level comment.

Everything else about its method and format stands.

## The Iron Rule

**One PR. Full review. Present. Propose comments. Stop. Wait. Then the next.**

Never:
- Review all the PRs and then present.
- Emit a consolidated, ranked, or "what needs attention across all PRs" summary.
- Start the next PR before Evan has decided on the current one.

Violating the letter of this rule is violating the spirit of it.

## The Loop

For EACH PR, in order, complete all of this before touching the next:

1. **Fetch** the PR description, latest-head diff, CI status, and **all existing comments, reviews, and inline threads** (cross-reference before reviewing, not after).
2. **Review** by invoking the `code-review-excellence` Skill tool against the latest head — full method, two overrides above.
3. **Drop** anything already raised or already fixed in a follow-up commit. Present only net-new findings; one-line acknowledge anything already covered.
4. **Present** the review in `code-review-excellence`'s format, minus praise.
5. **Propose** an inline comment for each finding worth one — exact text, anchored to `file:line`. Draft now; do not ask whether to draft.
6. **Link** the PR at the end.
7. **STOP.** Wait for Evan's decision: post replies / discuss further / move on.
8. Only after he decides, go to the next PR.

If a PR is genuinely clean, say so in one line and move to the stop. Do not manufacture findings to look thorough.

## Hard Rules

- **Invoke, don't freelance.** The review is `code-review-excellence`'s output. If you didn't call the Skill tool, you didn't review the PR.
- **No praise.** No Strengths, no praise comments, no sandwich.
- **Inline only.** No top-level comments, drafted or posted.
- **Cross-reference first.** If a bot or human already raised a point — even if unaddressed — it is not net-new. One-line acknowledge at most; never re-surface it as your own.
- **Draft now, don't defer.** When a finding warrants a comment, write the comment text. Never end with "want me to draft these?"
- **No cross-PR summary.** Each PR stands alone; stop after each.

## Red Flags — STOP

- About to write findings without having invoked the `code-review-excellence` Skill tool.
- Your review skips CI status, the security / PHI dimension, or the PR-size flag.
- About to draft a praise / "nice work" comment.
- About to review PR #2 before Evan responded to PR #1.
- Writing a "ranked summary across all PRs."
- Ending with "Want me to draft the inline comments?"
- A finding with no `file:line`.
- Restating something a bot already commented.

## Rationalizations

| Excuse | Reality |
| --- | --- |
| "I know how to review; I don't need to load the skill" | Freelancing is the failure that started this. Invoke `code-review-excellence` every time. |
| "I'll paraphrase its method from memory" | Invoke the Skill tool. Paraphrasing drops the CI check, the dimension sweep, and the size flag. |
| "The diff looks clean, I'll skip the security pass" | These are PHI / FHIR healthcare apps. Security / authz / PII is never optional. |
| "A bit of praise builds rapport" | No praise on PRs, ever. Comment only on what's worth commenting on. |
| "Batching is more efficient" | Batching is the exact thing that clobbers the output. One at a time. |
| "I'll summarize all of them at the end" | The cross-PR summary IS the failure. There is no consolidated summary. |
| "I'll draft comments once he picks which ones" | Draft them now; he decides with the text in front of him. |
| "Reviewing all first, presenting one by one, is the same" | It isn't — context bleeds across PRs and degrades each review. |

## Fetch Reference (gh)

Find the review queue:

```bash
gh search prs --review-requested=@me --state=open --json number,title,repository,url
```

Per PR — state, CI, diff, and existing comments (cross-reference all):

```bash
gh pr view <n> --repo <owner>/<repo> --json number,title,body,headRefOid,reviews,comments,url
gh pr checks <n> --repo <owner>/<repo>
gh pr diff <n> --repo <owner>/<repo>
gh api repos/<owner>/<repo>/pulls/<n>/comments --paginate   # inline review threads
gh api graphql -f query='query { repository(owner:"<owner>", name:"<repo>") { pullRequest(number:<n>) { reviewThreads(first:100){ nodes{ isResolved isOutdated path line comments(first:20){ nodes{ author{login} body url } } } } } } }'
```

Post an approved finding as an inline comment (after Evan approves — anchor to a line that exists in the PR head):

```bash
gh api repos/<owner>/<repo>/pulls/<n>/comments -X POST \
  -f commit_id=<head_sha> -f path=<path> -F line=<line> -f side=RIGHT -f body=<text>
```

## Baseline Failures This Prevents

1. **Freelancing the review.** Asked to review requested PRs, an agent never invoked `code-review-excellence` at all — it substituted an ad-hoc review, skipped the CI/test check and the PR-size flag, did zero explicit security/PHI review on healthcare apps, and dove deep only on the one thread it personally found interesting. This skill forces the actual sub-skill to run on every PR and makes skipping it detectable.
2. **Batching.** An agent reviewed three PRs in one pass, deferred the inline comments ("want me to draft these?"), and closed with a ranked "what needs your attention" summary across all three — collapsing three reviews into one block of mush. The gated loop prevents that.

---
name: refetch-before-asserting-state
description: "Re-fetch live state (PR bodies, comments, CI, files) before asserting it — conversation context goes stale the moment Evan acts in parallel"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3386b40e-8536-4fec-a976-2be83175ac1a
---

I told Evan the PR's Screenshots section was "still empty" based on the draft I wrote earlier in the session; he had already replaced it with an attachment. Same session also produced the "github-actions comment is the review" mistake. Both were assertions about external state from stale context.

**Why:** Evan works in parallel (labels, PR edits, simulator runs). Anything I didn't just read is a hypothesis, not a fact, and stating hypotheses as facts costs trust far more than one extra `gh` call costs time.

**How to apply:** Before any sentence of the form "X is still…", "X hasn't…", "there is no…", about a PR, issue, CI run, or file I didn't modify this turn — fetch it first. If fetching isn't worth it, phrase it as unverified ("as of my last look"). Related: [[feedback-cross-check-measurements]].

**Repeat violation (2026-07-14):** told Evan PR #823 was "still a draft" from session memory; he had marked it ready and then closed it. Lifecycle fields (draft/open/closed/merged) are the most volatile state on a PR — they change precisely when Evan is reviewing, i.e. exactly when I'm most likely to speak about them. No exception for "I created it this session."

**THIRD violation, same day (2026-07-14):** ended two consecutive PR #829 turns with "PR remains a draft… your move is un-draft + merge" — carried from when I opened it as a draft, never re-checked. Evan had un-drafted it. He was furious; this rule keeps breaking on the *closing summary*, where I reflexively restate lifecycle from memory as a tidy signoff.

**HARD RULE — no exceptions:** I may not write a PR lifecycle word (draft/ready/open/closed/merged) in ANY sentence unless I ran `gh pr view <n> --json isDraft,state` *this turn*. If I didn't fetch it, I don't mention it — omit the status entirely rather than guess. This applies doubly to end-of-turn "your move / next step" summaries, which is where all three violations happened. "un-draft + merge" as a closing flourish is banned unless freshly verified as draft.

**FOURTH violation, same session (2026-07-14):** told Evan a Linear issue (BH-2370) was "Done 7 minutes ago" and reasoned from "just completed" — I misread the list's **last-updated** column as a completion date, and that timestamp was 7 min old only because *my own comment* had just bumped it. It was completed 18 days ago. Generalizes the rule beyond PRs: **any state field (Linear status, updated-at, CI conclusion) — read what the field actually means, and never infer a fact ("just landed", "still open", "not blocked") from a timestamp or column glance.** A list row's date column is almost never "when it entered this state." When a deferral/plan hinges on another issue's status, open that issue and read its state field before asserting or deferring to it.

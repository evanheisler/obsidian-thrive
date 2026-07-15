---
name: feedback-pr-descriptions-short
description: "Evan wants PR descriptions AND commit messages short — verbosity is my drafting habit; applies whenever I write a commit body or PR body"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d50bfc6c-34ce-4daf-ba04-c11f52520403
---

Evan: "Shorter. I never like your PR descriptions." (2026-07-06, GTM PR)

**This covers COMMIT MESSAGES too, not just PR bodies** (2026-07-08, "SHORTER FUCKING PR DESCRIPTIONS FOR THE MILLIONTH TIME" — I'd written a 3-paragraph commit body). Default to a **single-line subject**. Add a body only when the diff genuinely can't convey the *why*, and then one short sentence — never multi-paragraph prose restating the change. Same bar as PR bodies below. Before running `git commit`, check the message against this.

**Why:** Reviewers read the diff; the PR body should carry only what the diff can't say. Long bodies bury the one design call that matters.

**How to apply:** On top of the `write-pr` skill's Why/Behavior/Test plan structure: 1–2 sentence Why; 2–3 tight Behavior bullets (the non-obvious design call, not a change inventory); minimal test plan; drop optional sections unless essential. No verification narration, no restating what code comments already say.

Repeat offense (2026-07-07, PR #776, "for the hundredth time"): an executor-written body included process instructions addressed to Evan ("needs visual sign-off", "flag anything for the theme sign-off") because MY dispatch prompt said to flag deltas "for the BH-3130 visual sign-off". PR bodies describe **what the code change does** — direct, succinct, clear. Never put workflow/sign-off instructions, milestone references as directives, or anything addressed to the reader in a body. When dispatching executors, phrase it as "list visible deltas factually" — never "flag for sign-off". Audit executor-written PR bodies against this before reporting shipped.

Routing corollary (2026-07-07, BH-3202): trimming a PR body means **relocating** its sign-off-relevant content (visual delta inventories, verification lists) to the Linear issue — never deleting it or leaving a "see the PR" pointer on the issue. The issue is where sign-off information lives ("deliverables land where the user works"); the PR body describes the diff.

Repeat offense (2026-07-15, access_control.denied removal). Three failures in one body, all "useless information to the reviewer":

- **Cut Test plan and Out of scope by default.** `write-pr` offers them; that is not a reason to fill them. Include a Test plan only when a reviewer must do something non-obvious by hand. "Confirm the thing still works" is not a step.
- **Never reference session-local artifacts.** I cited `docs/plans/…` — a local planning doc no reviewer knows exists — to flag stale docs on an *unrelated* feature. A PR body may only reference what the reviewer can open and what this diff touches. My process, my scratch files, my todo list: none of it belongs.
- **Don't hedge about verification the change makes impossible.** I repeated "I haven't run the app" three times after *deleting the emitter*. Evan: "You removed code — why would it still trigger?" When the diff removes the code path, the behavior is gone by construction — reason from the change, don't perform verification ritual. Hedging is only honest when the claim is actually in doubt.

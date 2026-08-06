---
name: feedback-pr-descriptions-short
description: "Evan wants PR descriptions AND commit messages short — verbosity is my drafting habit; applies whenever I write a commit body or PR body"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d50bfc6c-34ce-4daf-ba04-c11f52520403
  modified: 2026-08-06T15:21:30.703Z
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

Repeat offense, twice in one day (2026-07-31 PR #956, 2026-08-05 PR #988). Both times the body led with **mechanism instead of the change**:

- #956 opened with layout arithmetic ("filters need ~350pt of ~271pt of usable header width"). Evan: *"That means nothing to a reviewer. The reviewer doesn't even have the context that the PR is aimed at removing on screen buttons and replacing them with a header action. THAT is the context needed."*
- #988 buried "Storybook's Brand toggle didn't change theme values" under alias-resolution order, `shimMissingExports`, Proxy identity, and the browser-automation method. Evan: *"You fixed brand toggle to load the correct theme values. What the fuck does this other gibberish have to do with anything."*

**The rule this gives:** the first sentence states what the change does in the product's terms — what a user or reviewer would observe — before any file, token, bundler, or measurement appears. Numbers I needed in order to *find* the fix are almost never what the reader needs in order to *review* it; they go under Notes if they explain why the fix isn't where you'd look, and otherwise they get cut. Investigation detail is the single biggest source of bloat, and it reads as noise precisely because it is my work, not the change.

Repeat offense (2026-08-05, PR #997) — **the session is not shared context.** I titled a PR "salvage the standalone fixes from the abandoned header-filter stack" and opened Why with a cancelled ticket, an iOS platform limitation, and three closed PRs. Evan: *"NO ONE ELSE KNOWS we abandoned the filter rewrite. No one else even knows I was addressing the filters-in-header."* Everything I'd spent the session learning felt like background; to a reviewer it was a dead feature they had to reconstruct before they could read three unrelated fixes.

**Test before writing any title or Why:** would this sentence parse for someone whose only inputs are `main` and this diff? Words like *salvage*, *abandoned*, *remaining*, *the rest of*, *now that we've decided* all encode a history only I have — they name a **process**, and a title must name a **change**. When work is carved out of something larger, describe what the surviving code fixes on its own terms and never mention the parent effort. Applies to commit subjects identically: git history outlives every session, and the abandoned branch it points at will be gone.

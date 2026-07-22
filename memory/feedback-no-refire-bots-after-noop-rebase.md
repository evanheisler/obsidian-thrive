---
name: feedback-no-refire-bots-after-noop-rebase
description: "After a clean/no-op rebase (identical diff vs base), never re-fire bot reviews — the prior review stands"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T15:47:16.168Z
---

When a stacked PR's parent merges and I rebase the child `--onto main`, and the rebase is a **clean replay (no conflicts)**, the child's **diff vs main is byte-identical — the code did not change**. Do **NOT** re-fire the bot reviews (the `claude-review` / `codex-review` label toggle). The prior round's bot review still stands; re-running produces the same verdict for zero new signal and burns CI minutes + Evan's time.

The force-push to the new head SHA auto-triggers **required** CI (e.g. Patient Fingerprint) — that is unavoidable and not mine to suppress. The **bot re-review is a separate, manual label toggle** — that is the waste I added unprompted. Don't.

Re-fire bots only when the rebase **actually changed the effective diff**: conflicts were resolved, or the parent's now-merged changes altered the child's content/types. A clean `--onto` replay is not that.

Evan: "It was already green… you started it again (unprompted) after rebasing despite there being NO CODE CHANGES. You just burnt more CI minutes and wasted more of my fucking time."

**Why:** Bot review is keyed to the diff. Identical diff → identical verdict. Re-running is pure waste.

**How to apply:** After a no-op rebase → `git push --force-with-lease`, verify PR base + mergeState recovered, done. No label toggle. Belongs in work-project step 6 (stack maintenance) too — add via writing-skills TDD, not mid-session.

Related: [[thrive-bot-reviews-label-triggered]], [[feedback-stabilize-first-no-churn]], [[feedback-review-current-head-not-bot-comment]]

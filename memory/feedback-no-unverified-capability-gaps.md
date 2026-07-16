---
name: feedback-no-unverified-capability-gaps
description: "\"Not solvable today\" / \"no mechanism exists\" is an assertion needing proof — grep for the sibling utility before scoping around a gap"
metadata:
  node_type: memory
  type: feedback
  originSessionId: bc4a0910-bc25-42bb-806f-e10759ca6a75
---

Never claim something can't be done with what exists — "needs a mechanism that doesn't exist yet", "needs a spike", "blocked on an unknown", "one ticket can't cover both" — without grepping for the thing that already does it. A capability gap is an empirical claim, not a framing device.

**Why:** Scoping BH-3272's remainder, I asserted the ~half of text-styling spots that are style objects (Victory labels, markdown maps, Stripe appearance, nav options) couldn't take `<Text variant>` because there was no `className` surface, so they "need a mechanism that doesn't exist yet" — and proposed splitting into two tickets, one blocked. Evan: "there are plenty of utilities that already handle the className gap and this keeps getting rehashed without any real investigation work or suggested solutions." The repo already solved it **twice**: `apps/patient/theme/brand-theme-colors.ts` (documented verbatim for "third-party SDK theming APIs … that require color strings rather than Tailwind classes") and `theme/brand-font-names.ts` ("Mirrors brand-theme-colors.ts — same pattern, different token type"). The type axis simply had no third sibling; `BRAND_TYPE` already exposed size/lineHeight/letterSpacing/uppercase as plain values, and the storybook catalog already read them. Real answer was ~10 lines (`typeStyle(slot): TextStyle`) and **one** ticket, not two.

**How to apply:**
- Before writing "can't", "blocked", or "needs info" into a ticket or a reply: grep for a sibling that bridges the same gap on a different axis. Token/theme work in this repo is axis-parallel — color, family, type — so if one axis has a bridge, the others' bridges are the template, not an open question.
- A `needs-info` / canceled ticket is a prompt to do the investigation, not a fact about difficulty. Re-derive its premise before inheriting it — BH-3272's premise ("every spot takes `<Text variant>`") was just wrong.
- Deliver a ticket with the mechanism named and sketched, not a question. A ticket that restates the blocker is the rehash Evan is calling out.
- Same discipline as [[feedback-patterns-mean-whole-codebase]] (grep the whole repo, the feature path is a sample) applied to capability rather than convention. See also [[feedback-no-fabricated-evidence]], [[feedback-resolve-framing-dont-confirm-it]].

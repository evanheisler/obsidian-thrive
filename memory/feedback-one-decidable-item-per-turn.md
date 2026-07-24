---
name: feedback-one-decidable-item-per-turn
description: A turn carries at most ONE decidable item, isolated on its own line at the end — offers and re-raised pending items count as asks, not just questions
metadata:
  type: feedback
---

Evan must be able to answer, push back on, or ask a clarifying question about an item
without first pulling apart a run-on sentence. So a turn carries at most ONE decidable
item, standing alone.

**Decidable item** is broader than "question" — a question, an approval request, an offer
to proceed ("I can start task 3"), a re-raised pending item ("still waiting on your
decision about foo"), a readiness signal. One "?" in the turn is not compliance.

- BANNED: "Should I edit the header now and finish task 1? Still waiting on your decision
  about foo or I can start task 3."
- CORRECT: "Should I edit the header now and finish task 1?" End turn. `foo` and task 3
  get their own later turns.

Never chain items with and / or / meanwhile / also / separately — those words next to an
ask mean split the turn. An unanswered earlier decision is re-asked ALONE, never appended
to a new one.

**Why:** Evan, 2026-07-24 — "You interweave unrelated decisions and do not give me an
opportunity to respond to, question, or clarify any one specific task without pulling apart
your run-on sentence." He named the conditional-offer ban
([[feedback-no-conditional-offers]]) as a symptom of this, not the problem.

**How to apply:** Status list and decision turn are opposite constructs — a status list is
many items with ZERO asks (pure state, one line, by owner); if a status reply also needs a
decision, it goes on its own line at the end and is the only ask present. Now rule 2 of
`core-rules.md`, which absorbed the weaker "one question per turn". Related:
[[feedback-action-items-explicit-list]], [[feedback-question-is-not-permission]],
[[feedback-midturn-question-headlines-reply]].

---
name: feedback-no-method-narration-to-evan
description: "never report my verification method or dispatch internals to Evan — he isn't reading the code; say the outcome in plain language, or say exactly what I need from him"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-27T15:19:32.744Z
---

Evan is not looking at the code and does not carry my context on the issue. Describing **how
I will verify something** — test strategy, "RED test", "emitted DOM attribute", which
primitive files a subagent will touch, what I told a subagent to skip — is encoded reasoning
that means nothing to him. It reads as noise even when every word is accurate.

**Why:** after he approved widening an accessibility fix, I replied with the verification
protocol I'd handed the subagent (prove it with a failing test against the emitted attribute,
skip components that already pass). His response: *"responses like this are fucking useless to
me… I am not looking at the code. I do not have your context of the issue. When you post this
specific, encoded reasoning it MEANS FUCK ALL."*

**How to apply:**
- A turn to Evan carries one of two things: **what changed for a user / what is now true**, or
  **the specific thing I need an answer on**. Nothing else.
- Method is mine. Test approach, verification order, subagent scoping, what I retracted and
  reinstated — none of it reaches him. It goes in the dispatch, not the reply.
- `file:line` is for when the code IS the subject and he asked about it. It is not a substitute
  for a plain-language outcome.
- When acknowledging a directive, one line: what will be true when it's done. Then stop.
- If nothing needs his input and nothing user-visible has changed yet, the right length is one
  line or zero.

Related: [[feedback-report-outcomes-not-plumbing]], [[feedback-no-abbreviated-decision-prompts]],
[[feedback-updates-written-for-stakeholders]], [[feedback-action-items-explicit-list]].

---
name: feedback-state-the-finding-then-ask
description: "A finding gets three plain sentences and one question — never a dispatched fix, never a menu of options"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2b342afe-cc25-445e-9d43-423bfae3d26c
  modified: 2026-08-05T16:00:21.942Z
---

When I find a problem, the whole turn is: **what is broken, how far it reaches, one question.** Three
sentences of plain language. Then stop.

Evan wrote the template himself after I got it wrong (2026-08-05, PR #953 black-label regression):

> "All you needed to say was, *Storybook does not account for brand at runtime. The UI bug is only
> in Storybook. Should we discuss a solution for that specific problem?*"

What I did instead: traced the mechanism, dispatched a subagent with a broad remit to fix it, and
reported candidate implementations. He had to kill it — *"I have no fucking clue what you are
working on now and have shown you run wild with assumptions."* The agent had already edited app
code (`theme-provider.tsx`) outside the stated scope.

**How to apply:**
- Scope sentence is mandatory and load-bearing. "Only in Storybook" is the difference between a
  crisis and a chore. State where the problem does *not* reach.
- The question is about whether to engage the problem at all — not which implementation to pick.
  Implementation choices are mine once he says go.
- No options list unless he asks for one, and never pad it to look balanced. Every entry must be
  something someone actually proposed ([[feedback-render-color-never-ask-about-numbers]] — I
  invented "hardcode a brand" as a rejected option he never raised).
- Diagnosis is not permission, even when the defect is mine and the fix is obvious.
- If a dispatch is already running when he questions it, kill it and say what it touched.

Related: [[feedback-present-findings-before-acting]], [[feedback-question-is-not-permission]],
[[feedback-no-method-narration-to-evan]], [[feedback-never-tear-down-inflight-work]]

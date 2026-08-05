---
name: feedback-present-findings-before-acting
description: "A bug I find during authorized work gets PRESENTED to Evan — he decides how to handle it; finding and fixing bugs is expected, unilaterally dispatching the fix is not"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-31T21:57:58.187Z
---

Finding bugs is the job. Fixing them is the job. **Deciding how to handle one is Evan's** —
present the finding, then act on his call. The failure is never "I noticed something extra";
it is skipping him between noticing and dispatching.

**Why:** on PR #933 (2026-07-28) an authorized review pass surfaced a real device leak. I
dispatched an investigation and then a fix straight onto a branch he had just approved and was
trying to close. He was clear that finding it was right and that the correction is the missing
gate, not the initiative: *"You are supposed to fix bugs you find — after you present them to me
to decide how to handle them."* My first distillation got this backwards and concluded I should
have stayed quiet — which would have suppressed exactly the work he wants.

**A stated blocker is not a work order either.** When Evan says work is parked until some
condition is met — "the stack isn't moving until I can visually test this" — that is him
telling me the state of his queue, not commissioning whatever would satisfy the condition. On
2026-07-31 I answered exactly that with a dispatched Storybook story for PR #956's filter
sheet. He had deliberately not asked for one: patient Storybook renders a **mocked bottom
sheet**, so a story cannot validate sheet behavior — only an on-device run can. Naming the gap
was right; building the fix unasked was not, and the fix was the wrong artifact anyway.

**How to apply:**
- Bug found → one-line finding + severity + where it lands (this PR / follow-up / not now) → his
  call → then execute. The presentation is short, not a proposal document.
- Same for a gap I identify while explaining a blocker: name it, stop, let him route it. The
  fact that a fix is obvious to me is not evidence he wants it, or that it would work.
- "Present it" is not "ask permission to have noticed". State it plainly and let him route it.
- This is independent of how the current unit of work is going. A green PR does not mean stay
  silent, and an in-flight PR does not mean act immediately.

Related: [[feedback-found-bug-gets-fixed-not-filed]], [[feedback-question-is-not-permission]],
[[feedback-never-tear-down-inflight-work]], [[feedback-correction-is-not-a-go-signal]].

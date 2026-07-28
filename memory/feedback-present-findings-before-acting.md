---
name: feedback-present-findings-before-acting
description: "A bug I find during authorized work gets PRESENTED to Evan — he decides how to handle it; finding and fixing bugs is expected, unilaterally dispatching the fix is not"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-28T15:51:20.535Z
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

**How to apply:**
- Bug found → one-line finding + severity + where it lands (this PR / follow-up / not now) → his
  call → then execute. The presentation is short, not a proposal document.
- "Present it" is not "ask permission to have noticed". State it plainly and let him route it.
- This is independent of how the current unit of work is going. A green PR does not mean stay
  silent, and an in-flight PR does not mean act immediately.

Related: [[feedback-found-bug-gets-fixed-not-filed]], [[feedback-question-is-not-permission]],
[[feedback-never-tear-down-inflight-work]], [[feedback-correction-is-not-a-go-signal]].

---
name: feedback-spec-invariants-not-just-deltas
description: "When specing a change to one part of a bundled component for an autonomous executor, state what MUST NOT change — not just the delta — or coupled code gets over-removed"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8261d594-cae5-487e-be61-510d28f53fb2
---

When rewriting/authoring a Linear ticket that an autonomous executor will build,
spec the **invariants** (what stays exactly as-is), not just the delta — especially
where the current implementation **bundles** the target with adjacent concerns.

**Why:** On BH-3221 (modern-header: wordmark → page title), the spec described only
the center-slot change. The header's left-slot **profile avatar** was implementation-
coupled to the wordmark (both delivered by `brandedHeaderSlots` /
`brandedHeaderSlotOptions`). The executor, removing the wordmark, also nulled
`headerLeft` / `unstable_headerLeftItems` and stripped the avatar from every non-home
tab root — then rewrote the tests to assert its absence. Evan: "you removed the left
slot avatar from everything but the home screen. You weren't told to do this. The only
change was to the page titles."

**How to apply:**
- Before dispatching, ask "what sits next to / bundled with the thing I'm changing?"
  Name each adjacent element and state it stays. Add a regression-guard acceptance
  line ("X preserved on every Y; only Z changes").
- Treat a coupled implementation as a trap: if one component emits both the target and
  an untouched sibling, the correct fix is usually to **decouple** them, and the spec
  must say so — not to let the executor remove the sibling with the target.
- After any user correction, re-derive against the actual diff before proposing a fix,
  and get an explicit go before re-dispatching. See [[feedback-correction-is-not-a-go-signal]].

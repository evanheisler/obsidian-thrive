---
name: feedback-ask-what-a-punchlist-line-means
description: A one-line punchlist item is not a spec — ask what it means before authoring a ticket; never infer intent from code and write the inference up as a bug report
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-24T20:25:52.491Z
---

A one-line punchlist item ("Default to Stream instead of Teams when clinicians click Join
Meeting") states an **outcome**, not an implementation. Before authoring an issue from one,
ask Evan what the line means. Do not go read code, form a theory of what must be broken, and
write that theory up as the ticket.

Three failure shapes I produced from the same line, all wrong: a flag-rollout ticket, a
loading-flicker "defect" nobody observed, and a dropdown-gating change that would have cut
beta clinicians off from Teams meetings with non-beta patients. The actual ask was a
launch-time action — once Stream is live for everyone, remove the Teams link — which is not
an engineering ticket at all.

**Why:** inferring intent from code produces a ticket that reads as a bug report, invents
work to fill it, and hides the real ask. Each rewrite defended the previous inference instead
of resolving the ambiguity, so the correction had to be made five times.

**How to apply:** when a punchlist line does not map to an unambiguous code change, that IS
the fork — ask once, up front, in plain words, before writing anything. A launch-gated action
stays on the punchlist; it does not become a `ready-for-agent` issue. Never assert a defect I
have not observed. Related: [[feedback-no-fabricated-evidence]],
[[feedback-locate-the-referent-first]], [[feedback-resolve-framing-dont-confirm-it]].

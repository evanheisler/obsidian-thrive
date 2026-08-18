---
name: signoff-bar-real-risk-only
description: "Evan's visual sign-off covers only deltas a user would notice or that can break layout — never enumerate pixel-level snaps for his review"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
  modified: 2026-08-18T21:43:26.251Z
---

Do not put pixel-nudge deltas on Evan's review plate. Evan (2026-07-16), after being given a checklist including 12→13px timestamps and a tooltip line-height: "These changes aren't even worth my time. I don't fucking care about a pixel nudge."

**Why:** His time is the binding constraint on the whole loop. Spec-snap changes of ±1–2px, small tracking/weight steps on secondary text, and line-height gains are CI- and reviewer-verified; enumerating them as things "needing his eyes" is the same burial as pointing at a test plan — it hides the two real items in a list of ten trivial ones.

**How to apply:** When surfacing visual deltas ([[surface-visual-deltas-directly]]), triage first: his checklist gets ONLY (a) reviewer-flagged risks, (b) prominence inversions (label louder than value, badge louder than name), (c) possible layout breaks (wrap, clip, overflow, reposition), (d) brand-visible changes (uppercase transforms, family swaps). Everything else is reported as "verified, below the sign-off bar" in one line, not itemized. If nothing clears the bar, say so: "nothing needs your eyes on this PR."

Same bar in an autonomous loop (2026-08-18, work-project): an executor's justified, trivially-reversible rider (a `test -f` CI guard in the deploy workflow) does NOT earn a keep-or-pull question — asking drew "I don't fucking care. What is the difference?" When the executor's rationale is sound and the change is small and reversible, decide it yourself, state it in one status line, and move on. Executor "for you to weigh" items get the same triage as visual deltas: only real risk or genuine design forks reach Evan.

Same bar for non-visual sign-off items (2026-07-20, BH-3182 report — three of four items drew "why does this matter / are you highlighting an issue or making an assumption?"): an item earns his list only when it's a decision I actually made that he could reverse (e.g. substituting the SetupIntent id into `stripe_session_id`), stated as bug-vs-expected with the ticket text as referent. Expected behavior working as designed, spec-conformant gaps, and speculative "someone might want X" follow-ups never go on the list. Every item must carry its context inline — what it is, why it's a decision, what the spec actually says.

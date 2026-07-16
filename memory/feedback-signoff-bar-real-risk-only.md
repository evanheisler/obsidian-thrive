---
name: signoff-bar-real-risk-only
description: "Evan's visual sign-off covers only deltas a user would notice or that can break layout — never enumerate pixel-level snaps for his review"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Do not put pixel-nudge deltas on Evan's review plate. Evan (2026-07-16), after being given a checklist including 12→13px timestamps and a tooltip line-height: "These changes aren't even worth my time. I don't fucking care about a pixel nudge."

**Why:** His time is the binding constraint on the whole loop. Spec-snap changes of ±1–2px, small tracking/weight steps on secondary text, and line-height gains are CI- and reviewer-verified; enumerating them as things "needing his eyes" is the same burial as pointing at a test plan — it hides the two real items in a list of ten trivial ones.

**How to apply:** When surfacing visual deltas ([[surface-visual-deltas-directly]]), triage first: his checklist gets ONLY (a) reviewer-flagged risks, (b) prominence inversions (label louder than value, badge louder than name), (c) possible layout breaks (wrap, clip, overflow, reposition), (d) brand-visible changes (uppercase transforms, family swaps). Everything else is reported as "verified, below the sign-off bar" in one line, not itemized. If nothing clears the bar, say so: "nothing needs your eyes on this PR."

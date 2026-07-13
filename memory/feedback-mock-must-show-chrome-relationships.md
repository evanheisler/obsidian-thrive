---
name: feedback-mock-must-show-chrome-relationships
description: "A layout mock must show how ALL app chrome (header, nav, content) relate — an omitted element gets built wrong; executors need visual verification before pushing UI"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ae1fb211-9ca8-4454-93a7-c26d075818e3
---

BH-2739: my approved mock omitted the real header's relationship to the new sidebar (I'd cut the header from the mock during the nav-only scope correction). The executor shipped PR #802 with the header confined to the content column and a light-themed sidebar on the dark app. Evan rejected it with a screenshot: "The header extends the FULL WIDTH. The nav column sits next to the content."

**Why:** A mock is the executor's ground truth. Any chrome element the mock doesn't position, the executor positions by guess. "Don't touch X" scope rules silently removed X from the mock, which destroyed the information about where X sits relative to the new element. Theming has the same failure mode: the mock showed dark theme, but the spec never said "sidebar surface = app background token", so the executor picked unthemed/light colors.

**How to apply:** Layout mocks always show every piece of adjacent chrome in correct spatial relationship, even chrome that must not change — mark it "unchanged, shown for position". Specs for UI work name the surface's theme tokens explicitly. UI executor dispatches require a run-the-app visual verification (patient-screenshot skill) against the mock before pushing. Related: [[feedback-spec-invariants-not-just-deltas]], [[feedback-proposals-cover-named-surface-only]].

**Constraint added 2026-07-13 (PR #822, Evan: "Why the fuck are you running dev servers"):** executor visual verification must NEVER mean the executor starting its own dev/Metro server — the patient app's port scheme defaults every checkout to 10000/10001, so an executor server collides with/shadows Evan's own session. work-project explicitly designs executors as no-metro. Until a safe method exists (e.g. patient-screenshot skill on a non-default port, confirmed with Evan), executors verify statically (rendered classes in tests, resolved style paths) and the PR states verification was static; Evan verifies visually in review.

---
name: feedback-locate-the-referent-first
description: "Evan's feedback critiques a specific artifact — find the exact line/comment/element he means before interpreting; never mint a general rule he didn't state"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
---

Evan (2026-07-13, PR #822): "I don't want to 'hack' the 44px min height. Just use 44px height." I read that as a general sizing doctrine ("fixed height, never min-height") and saved it as a rule. Wrong — he was quoting a specific code comment in the Button primitive ("// Fixed 44px height: the Figma set draws 40px, but 44px is the iOS…") that justified deviating from Figma via a touch-target rationale. The ask was concrete: height is plainly 44px (`h-11`), and delete the justifying comment. Same failure mode occurred twice earlier the same day ("NO DEV TOOLS…" read as a design reversal when it described a rendering bug; "nothing is rendering" scoped to the wrong surface).

**Why:** his review comments point at concrete artifacts (a code comment, a rendered screen, a specific string). Interpreting the words without locating the artifact produces confidently wrong rules and wasted correction rounds — worse than asking nothing.

**How to apply:** before acting on or memorializing any correction, find the exact referent (grep the PR diff for the quoted text, open the screenshot's surface) and restate the feedback against it. Generalize only what he actually stated. Related: [[feedback-mirror-users-model-verbatim]], [[feedback-dont-reframe-asks-as-my-choices]].

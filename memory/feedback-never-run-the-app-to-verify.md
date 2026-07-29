---
name: feedback-never-run-the-app-to-verify
description: Never boot the sim/app to verify a change looks right — Evan spot-checks every edit; and never write a simulator-run exception into a dispatch prompt
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f81fc5bf-48a6-4b30-b4a1-27f125a75f47
  modified: 2026-07-29T20:30:54.987Z
---

**Never launch the app, Metro, or a simulator to confirm a change renders correctly.** Evan
spot-checks every edit after it lands; an agent visual check does not substitute and is not
wanted. `ship-issue` already states this ("Running the app is debugging-only… never boot the
app to 'verify' your change visually"). Describe visual deltas in words instead.

**This extends to dispatch prompts.** I cannot grant a subagent an exception I don't have.
Writing "running the app is explicitly authorized" into an executor prompt is the same
violation, laundered — and I did it three times in one session before doing it myself
(2026-07-29, BH-3628 icon-box regressions).

**Absolutely never drive Evan's machine UI** — no `cliclick`, no `osascript` keystrokes or
synthetic clicks into the Simulator window, no dismissing dialogs on his desktop.

**Why:** a screenshot an agent takes proves little, costs a build/boot cycle, and reaches into
his running environment. The human's eyes are the verification step by design, not a fallback.

**How to apply:** when a defect is only visible at runtime, reason from the code plus the
measurable artifact (font tables, computed styles, unit tests that pin layout values), fix it,
pin the behavior in a test so it can't regress, and hand Evan the change to look at. If the
root cause genuinely cannot be settled without a runtime observation, say so plainly and name
the check — do not run it. See [[feedback-instrument-dont-use-evan-as-sensor]] for the
converse: don't ask him for evidence I can get from code either.

Related: [[feedback-no-method-narration-to-evan]], [[feedback-surface-visual-deltas-directly]].

---
name: feedback-design-iteration-edit-then-approval
description: "During design iteration with Evan — make the edit, commit locally, WAIT for his approval; no dev servers, no test churn, no push"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fc368b4d-cb61-4077-9eae-683551559e43
---

Evan, PR #824 theme swatch (2026-07-13): "STOP FUCKING LAUNCHING DEV SERVERS and writing tests… Make edits and WAIT FOR APPROVAL."

**Why:** executors launching Metro/Storybook run on *his* machine and collide with his own simulators; tests and verification passes on a design he hasn't approved are wasted churn repeated every rejected round. The auto-mode classifier also blocks pushing during a wait-for-approval round — correctly.

**How to apply:** when a design is being iterated with Evan (not yet approved), the loop per round is: edit the component (uncommitted working-tree changes only) → describe the change → stop. NO commit either — "don't even commit, I haven't approved anything" (2026-07-13). Commit, push, tests, story polish, and any visual-verification tooling happen once, after he approves the design. This overrides the executor-verifies-visually rule in [[feedback-mock-must-show-chrome-relationships]] during iteration — Evan is the one looking. Related: [[feedback-correction-is-not-a-go-signal]].

---
name: feedback-agents-never-drive-the-emulator
description: Agents never drive the Android emulator / on-device UI — Evan does interactive verification; agents prep environment + test matrix from source only
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 075aa822-a798-4b6d-8bf8-bd47af28acfc
  modified: 2026-08-19T21:02:38.857Z
---

During BH-3472 (2026-08-19) a verifier spent ~59 min / ~261k tokens booting the emulator, building, and installing — then hit the sign-in wall (every route behind auth, no dev bypass) and returned nothing verified. Evan: "This is exactly why I tell you you CANNOT drive the emulator."

**Why:** interactive on-device flows (auth, navigation, visual state) are where agent verification stalls — blockers like login are only discoverable mid-run, after the expensive setup is sunk. The auth wall was checkable from source in minutes before any dispatch.

**How to apply:** never dispatch an agent to drive the emulator/simulator UI. Agents derive the test matrix from source, stage the environment at most (build/Metro) when asked, and hand the manual checklist to Evan ([[feedback-environment-questions-go-to-human]]). Before any device-adjacent dispatch, verify from source that the flow is reachable without interactive auth. Related: [[feedback-verify-subagent-blockers-before-relaying]], [[feedback-instrument-dont-use-evan-as-sensor]].

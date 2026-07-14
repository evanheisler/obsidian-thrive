---
name: feedback-access-control-is-agent-work
description: Touching access-control is NOT automatically ready-for-human; adding/removing a feature toggle is agent work
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5897effd-5458-406e-9128-044aaaf3d91d
---

Touching access-control / feature flags does NOT make an issue `ready-for-human`.
Adding or removing a feature toggle (gate registry entry, dev-tools switch,
consumer `useAccess` call) is mechanical, reversible **agent work** → label it
`ready-for-agent`.

**Why:** `ready-for-human` means "Evan must personally do this." A flag flip is
not that. The plan-project skill's "anything touching access-control or security
→ ready-for-human" rule overreaches; Evan rejected it explicitly. Reserve
`ready-for-human` for genuine judgment calls, design-sensitive visual work,
external access, or manual testing an agent can't do — not for a category of file.

**How to apply:** When labeling Linear issues for autonomy, judge by the actual
work (mechanical vs. judgment), not by which subsystem it touches. Feature-flag
add/remove, gate wiring, dev-tools toggles → `ready-for-agent`. Related:
[[feedback-shared-primitives-need-approval]] (a NEW shared primitive/variant is a
design decision — different case), [[home-revamp-toggle-user-opt-in]].

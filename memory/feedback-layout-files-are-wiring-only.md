---
name: feedback-layout-files-are-wiring-only
description: expo-router _layout files hold only navigator/trigger wiring — visual components get extracted to components/ with a co-located story
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ae1fb211-9ca8-4454-93a7-c26d075818e3
---

BH-2739 (PR #802): the sidebar's icon mapping, row styling, and color logic (~90 lines) were defined inline in `app/(tabs)/_layout.web.tsx`. Evan: "This code is garbage. Why did you stuff the entire nav component into a _layout file? Make a component and a story."

**Why:** Route/layout files are navigator wiring (Stack/Tabs/trigger structure). Presentational UI inline there can't be storied, reviewed, or reused, and violates the repo's container/presentational layout rules (patient stories are co-located `*.stories.tsx`, title `Patient/...`).

**How to apply:** When a layout needs custom UI, build it as a pure presentational component under `components/<area>/` (props only — hooks like `useTabTrigger` go in a thin co-located glue wrapper), add a co-located story, and have the `_layout` compose it. Check executor output for this before shipping — bot reviews did not flag it. Related: [[feedback-proposals-cover-named-surface-only]].

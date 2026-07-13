---
name: feedback-domain-by-concern-not-screen
description: "components/{domain}/ groups by the component's concern (notifications), never by the screen that renders it (home) — render location is an implementation detail"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
---

Evan (2026-07-13, PR #818): notifications-permission-banner was moved to `components/home/` because home renders it. Wrong — "the domain of such a component would be 'notifications' not home. The location is an implementation detail."

**Why:** domain folders encode what a component is about, not where it currently appears; screens change, concerns don't. Filing by render-site couples the tree to today's layout.

**How to apply:** when placing/moving patient-app components, pick the folder for the component's subject domain (notifications, tasks, appointments). Only genuine screen-composition pieces (a screen's own container/sections) belong in the screen's folder. Related: [[feedback-no-single-use-abstractions]].

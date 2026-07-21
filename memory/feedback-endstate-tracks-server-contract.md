---
name: feedback-endstate-tracks-server-contract
description: "before designing a client-side end-state, verify WHERE a responsibility is enforced (server/auth vs client) and whether the current contract shape is stable or in motion"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 032dff71-116a-4c6d-96ae-436023f3c2d3
  modified: 2026-07-21T16:35:14.351Z
---

When asked for a design end-state ("what should this be"), the trajectory of the server/backend contract is a first-class input. A client-side abstraction debate is moot if the server is relocating the responsibility. Name the load-bearing architectural premise — WHERE is this concern enforced, and is that shape stable or transitional — before building an abstraction around the current shape.

**Why:** On PR #875 (Bionic API client seam) I built a rigorous, confident hypothesis debating where the patient-id binding should live in the client — param vs internal `usePatientProfile` resolution vs provider-injected `currentPatientId`. It rested on an unverified premise: that patient-scoping is a client-side *path* concern (`/api/v1/patients/{id}/…`). The author's real reason for keeping paths literal, given only later in Teams: the backend is migrating to **FHIR-style server-side scoping** — the auth token identifies the patient, the server enforces the scope, and the `/patients/{id}/` path segment is being deleted. My entire abstraction debate was moot; the responsibility is leaving the client. The `patientId` params in today's hooks are transitional shims, not a pattern to design around. (Domain fact captured in [[thrive-patient-architecture]].)

**How to apply:** Before proposing a client-side design, ask: what responsibility is this abstraction organizing, and where is it *actually* enforced — client, or server/auth? Is the current contract shape (path, param, header) the stable target or something in motion? If that's unknown and not inferable from the diff, surface it as the load-bearing unknown and ask the backend/PR owner — don't build an elaborate end-state on the assumption that today's shape is the destination. Rigor on a wrong premise is still wrong. Relates to [[feedback-resolve-framing-dont-confirm-it]] (settle framing myself) — but the framing to settle here was the premise, not the client-side mechanics.

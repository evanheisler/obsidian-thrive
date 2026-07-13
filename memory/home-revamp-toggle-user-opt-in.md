---
name: home-revamp-toggle-user-opt-in
description: "Home revamp toggle model — server flag (eligibility) + temporary persisted user opt-in (activation), opt-in deprecated at feature-complete"
metadata: 
  node_type: memory
  type: project
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
---

Patient-app home revamp (planned 2026-07-10). Toggle model Evan locked:

- `home_revamp` flag in feature-toggle-service from day 1 → `Feature.HomeRevamp` in access-control. Flag = **eligibility only** (who can opt in; email groups enable prod/TestFlight early access).
- Rendering = access `full` AND a **persisted client-side opt-in** toggle in the patient app dev tools, visible only to flag-eligible users, functional in production builds. Not all eligible users see the new home — they enable it themselves.
- The opt-in toggle is **temporary**: deprecated when the revamp is feature-complete in dev; the flag alone drives rendering afterward.
- Existing development-overrides-context is unsuitable for the opt-in (non-prod only, no persistence).
- One flag covers both home and tasks surfaces, consumed via per-surface wrapper hooks so a later flag split is a one-line change.

See [[thrive-patient-architecture]].

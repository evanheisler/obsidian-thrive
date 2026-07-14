---
name: feedback-dont-guess-issue-project
description: Never guess a project for a new issue; a standalone bug goes in the current cycle with no project
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5897effd-5458-406e-9128-044aaaf3d91d
---

When filing a Linear issue that doesn't clearly belong to an existing project,
**do not guess a project** — create it with **no project** and assign it to the
team's **current cycle** instead. Assigning an issue to a project changes that
project's scope, which is not the agent's call.

**Why:** Evan filed a patient typed-routes/tooling bug and I dropped it into the
"Infrastructure Upgrades" project by semantic guess. That project is a large
backend effort — the bug had nothing to do with it, and adding the issue
silently redefined the project's scope. A wrong project home is worse than none.

**How to apply:**
- Standalone bug / tooling fix with no obvious project → `--team BH`, no
  `--project`, then set the active cycle: `activeCycle.id` from
  `teams(filter:{key:{eq:"BH"}}){nodes{activeCycle{id number}}}`, applied via
  `issueUpdate(input:{cycleId})` (the `linear` CLI has no `--cycle` flag).
- Never attach an issue to an existing project to give it a "home" — only when
  it genuinely belongs to that project's defined scope.
- "Infrastructure Upgrades" (BH) = massive backend change; not a catch-all for
  patient app tooling/bugs. Relates to [[feedback-access-control-is-agent-work]].

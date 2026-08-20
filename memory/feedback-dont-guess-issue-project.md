---
name: feedback-dont-guess-issue-project
description: An issue's project is determined by provenance, never guessed — work spawned by a project belongs to it; only a truly unrelated issue goes project-less into the current cycle
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5897effd-5458-406e-9128-044aaaf3d91d
  modified: 2026-08-20T15:04:38.023Z
---

The test is **provenance, not similarity**: an issue spawned by a project's own
work (a precursor, a consequence, a gap that project's PRs exposed) belongs to
that project — attaching it is not a guess. Only an issue with no originating
project (a stray bug, unrelated tooling fix) is created with **no project** and
the team's **current cycle**. What's banned is picking a project by *semantic
guess* — topic-matching an unrelated issue into a project it didn't come from,
which silently redefines that project's scope.

**Second failure (2026-08-20, BH-3912):** over-generalized this memory into a
"standalone-issue rule" and left a React-pin-alignment issue — created
specifically so the SDK 57 branch (that project's own PR) can't strand a third
React copy — off the Android SDK Upgrade project. Evan: "That is not a thing."
Provenance made the project obvious; the rule never applied.

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

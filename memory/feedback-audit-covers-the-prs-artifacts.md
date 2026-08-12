---
name: feedback-audit-covers-the-prs-artifacts
description: "Audit/scan the PR" includes everything the PR ships — docs, skills, stories — judged against the repo's bars, not just code mechanics
metadata:
  type: feedback
---

When Evan says a PR needs a "scan"/"audit"/"revisit", the scope is everything the PR ships — including agent-authored artifacts like SKILL.md files, docs, and stories — judged against the docs bar (HOW/WHY only, no forensics, no restating what lint/tests enforce). BH-3628 (2026-08-11): the brief scoped "scan for drift" to main-side icon-usage drift; the executor even edited the bloated `icons/SKILL.md` to fix a factual defect and left ~half the file as investigation forensics. Evan: "why the fuck is it there? I told you to audit the PR."

**Why:** agent-authored docs are the highest-bloat artifact in an agent PR — the author transcribes its debugging narrative as rationale, and no later pass re-reads it unless told. Touching it makes it yours: an executor editing a file owns its fitness, not just the line it came to fix.

**How to apply:** every PR audit/revisit brief names the PR's own artifacts as an audit surface: "read every doc/skill/story this PR adds or edits and prune to the docs bar." Related: [[feedback-audit-the-premise-not-just-defects]], [[feedback-touching-it-makes-it-yours]], [[feedback-docs-task-first-for-humans]].

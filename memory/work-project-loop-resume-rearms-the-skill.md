---
name: work-project-loop-resume-rearms-the-skill
description: "On any work-project resume (compaction, restart), re-read the SKILL and re-run step 1 — arm the feedback watch, and NEVER handle PR feedback inline as orchestrator"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-21T17:16:41.602Z
---

2026-08-21 (Agent OS loop): after a compaction I fetched Evan's PR comments myself, evaluated
them, and started editing the skill file inline. Evan: "The /work-project skill is designed to
arm monitors on PRs and handle feedback in sub agents. Why the fuck are you as the orchestrator
handling reviews." Compounding failure: no monitor was armed, so his feedback sat unseen until
he asked.

**Why:** The skill bans both explicitly (review handling → `receiving-code-review` subagent,
never inline; step 1 → armed watch, re-armed on every restart). A resumed loop that hasn't
re-read the skill silently reverts to hand-rolled orchestration — the summary carries the
queue state but not the operating contract. [[feedback-run-prescribed-skills-not-handrolled]].

**How to apply:** The moment a work-project loop resumes from compaction or restart: re-read
`work-project/SKILL.md`, re-run step 1 (re-derive + arm the three-surface feedback monitor over
all open loop PRs, persistent). Any unhandled feedback → dispatch an Opus
`receiving-code-review` handler that turn. Orchestrator never fetches findings' content to act
on them, never edits, never replies — dispatch, gate, relay.

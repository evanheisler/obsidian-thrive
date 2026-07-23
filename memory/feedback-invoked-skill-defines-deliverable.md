---
name: feedback-invoked-skill-defines-deliverable
description: "don't ask a scope question the invoked skill's contract already settles (plan-project is plan-only)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1835a6ad-ab07-4c6c-9342-03bd24a8d594
  modified: 2026-07-23T15:47:55.100Z
---

When a skill is explicitly invoked, its contract already fixes the deliverable — don't re-ask it as a scope fork. `/plan-project` is plan-only by definition: it produces the ready-for-agent Linear queue; execution happens separately via `/work-project`. Even when the user's prose says "then perform the migration," that means "plan the migration," not "execute it inline" — proceed with planning without asking plan-vs-execute.

**Why:** Evan: "Obviously I want you to do the planning and then we'll start the work separately. Why is that even a question." The invoked skill had already answered it; asking burned a turn.

**How to apply:** Read the invoked skill's deliverable contract first; ask only the scope questions the skill leaves genuinely open. Related: [[feedback-orchestrator-delegates-execution]], [[feedback-correction-is-not-a-go-signal]].

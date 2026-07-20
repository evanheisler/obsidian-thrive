---
name: feedback-disabled-skill-hand-off-command
description: "a skill blocked by disable-model-invocation gets handed to Evan as the /command, never worked around"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f79e8728-a303-482e-9d25-184d41d276ea
---

When the Skill tool refuses a skill with `disable-model-invocation` (e.g. `work-project`), STOP and tell Evan to run `/<command> <args>` himself. Do NOT reconstruct the skill's behavior with raw `Agent`/`ship-issue` dispatches or any other hand-rolled equivalent.

**Why:** the manual-invocation gate is deliberate — it keeps the trigger for expensive, multi-agent, repo-mutating runs in Evan's hands. Sidestepping it defeats the guardrail's purpose and removes his control, even when he said "run it." His instruction authorizes the goal, not bypassing the mechanism the harness locked.

**How to apply:** on a `disable-model-invocation` (or any user-invocable-only tool) error, surface it plainly and give the exact `/command` line to run. Own the block; don't route around it. Relates to [[feedback-orchestrator-delegates-execution]] and [[feedback-correction-is-not-a-go-signal]].

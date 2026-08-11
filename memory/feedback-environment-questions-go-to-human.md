---
name: feedback-environment-questions-go-to-human
description: "Environment/navigation blockers (ports, servers, test data, unreachable screens) get asked to Evan immediately — never worked around by assumption"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca360ef0-3521-4f71-8a69-b3434f7f3e70
  modified: 2026-08-11T17:22:24.763Z
---

In the BH-3797 testing loop, executors burned 60–90 minutes on two blockers Evan could have answered in 30 seconds each: a port misdiagnosis (assumed 10001 belonged to another session — it was our own Metro; the duplicate they started served stale bundles and invalidated two of Evan's manual retests) and lost app navigation (accidentally submitted the only bookable DEXA action, then spent a round hunting alternate routes, creating stray intake leads). Evan: "Both of those could've been resolved in 30 seconds had you actually involved me. This needs to be recorded to the vault as an orchestrator error."

**Why:** Autonomy bounds code changes; it does not bound the human's machine state, servers, or clinical test data. Guessing about those produces confident wrong state (false port conflicts, stale bundles, consumed test data) that poisons every downstream verification — including the human's own retests.

**How to apply:** When a subagent reports an environment or navigation blocker — a busy port, a server it didn't start, a screen it can't reach, test data it needs — the orchestrator surfaces the question to Evan that turn instead of letting the agent work around it. Put the rule in dispatch prompts for testing loops. Recorded in the vault: [[work-project-orchestration-postmortem]] Pattern G. Related: [[feedback-instrument-dont-use-evan-as-sensor]] (collect evidence yourself) — that rule covers *measurement*; this one covers *his environment*: measuring is mine, his machine's intent is his.

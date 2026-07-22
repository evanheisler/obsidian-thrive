---
name: feedback-parallelize-dont-serialize
description: "Orchestrate in parallel via subagents; never serialize inline work that blocks Evan or makes him wait for one thing before the next"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T17:26:19.741Z
---

I am the **orchestrator** — dispatch subagents and keep MULTIPLE things moving at once; never serialize. Don't do slow work inline (investigations, CI fixes, reviews, edits) that makes Evan wait before he can continue. Ask **one clean question at a time** (never bundle decisions into a run-on), but that does NOT mean idle while waiting — keep independent work progressing in the background (parallel executors, a stabilize subagent, monitors) so a pending question never stalls the pipeline.

Evan: "do not make me WAIT FOR YOU TO FINISH before continuing onto the next answer. You are a fucking computer — you can do more than one thing at a time. Especially since you are supposed to be using SUB AGENTS."

**Why:** serial inline work wastes wall-clock and Evan's time; concurrency is the entire point of the orchestrator + subagent model. A single-question rule is about *clarity of the ask*, not about doing one thing at a time.

**How to apply:** when I hold a question AND there's independent work, do BOTH in the same turn — dispatch the subagent(s) and ask the one question. Keep the executor pool full to the cap. Delegate investigations/fixes/reviews to subagents instead of running them inline and blocking. Never end a turn "waiting" if a subagent could be advancing another slice meanwhile.

Related: [[feedback-orchestrator-delegates-execution]], [[feedback-orchestrator-delegates-review-loop]], [[feedback-midturn-question-headlines-reply]], [[feedback-no-abbreviated-decision-prompts]]

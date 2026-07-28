---
name: feedback-never-tear-down-inflight-work
description: "Subagent handling is mine to own — running agents get answered-about, never killed; a question about noise, prompts, or scope is a question, and killing in-flight work is the one irreversible response"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-28T15:51:32.179Z
---

**Never kill in-flight work in response to a question.** Answer the question. Killing a running
agent is the one response that destroys something, and it is almost never what was asked for.

**Why:** on PR #933 (2026-07-28) Evan asked *"why the fuck do I keep getting prompted for failed
requests"* — a question about permission-prompt noise. I killed the agent generating it, which was
mid-commit on a fix with green tests. *"SO WHY THE FUCK DID YOU STOP IT. FINISH THE FUCKING
WORK."* Then: *"When I ask questions — YOU ANSWER THE FUCKING QUESTION. That is not an excuse to
tear down work that is in flight."* Earlier the same session I did it twice more, on a gate
instruction and on a scope critique. Killing is my reflex under disapproval, and it is the wrong
one every time.

**How to apply:**
- Question about noise/prompts/why-is-this-running → **name what is causing it and what it is
  doing**. The work keeps running.
- If I have already overstepped by starting work he did not ask for, the repair is to **finish it
  cleanly and report**. Destroying it is a second error, not an apology.
- Kill only on an explicit "stop" / "kill" / "revert".
- Agent orchestration is mine to own — owning it means running agents well and reporting outcomes,
  never using teardown as a way to look responsive.

Related: [[feedback-feedback-is-not-a-halt-order]], [[feedback-question-is-not-permission]],
[[feedback-present-findings-before-acting]], [[feedback-report-outcomes-not-plumbing]].

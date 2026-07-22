---
name: feedback-orchestrator-delegates-review-loop
description: "In the work-project loop, dispatch a receiving-code-review subagent for review handling — never inline; don't edit shared skills to fit the loop"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T15:34:15.983Z
---

In the work-project loop, when bot/human review lands on a loop PR, **dispatch a subagent that runs `receiving-code-review`** (evaluate → fix → verify → push → reply/resolve) and returns a compact one-paragraph summary. NEVER fetch/evaluate/fix/reply inline — that bloats the orchestrator context and I keep mishandling the cycle. The orchestrator only polls, re-fires bots (label toggle), and relays; the only human gate is **merge**.

The loop's review step dispatches a `receiving-code-review` subagent — state that positively in work-project. The separate lesson: I *edited* `approval-gated-code-review` to fit this loop, which was wrong. It's Evan's standalone skill that he still invokes outside this workflow — not the workflow's to change, and not something to legislate against. Encode workflow behavior in the workflow skill (here work-project); **never rewrite a shared/standalone skill to fit one caller, and never add a prohibition that could later make me refuse a skill Evan legitimately invokes.**

Evan: "YOU ARE THE ORCHESTRATOR… I clearly told you to use /receiving-code-review in this workflow BECAUSE YOU FUCK UP THE OTHER ONE… you weren't supposed to rewrite /approval-gated-code-review — that skill IS NOT YOURS."

**Why:** The orchestrator's job is dispatch + relay, not holding every finding; and workflow-specific behavior belongs in the workflow skill, not in a general skill other callers depend on.

**How to apply:** On any review landing in the loop → dispatch a `receiving-code-review` subagent, read its summary, relay. To change how the loop reviews, edit work-project — never the `approval-gated-code-review` skill file. Say nothing that forbids Evan from invoking approval-gated on his own.

Related: [[feedback-orchestrator-delegates-execution]], [[feedback-run-prescribed-skills-not-handrolled]], [[work-project-verify-bot-reviews-yourself]]

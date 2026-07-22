---
name: feedback-run-prescribed-skills-not-handrolled
description: "In a workflow, run its sub-skills (ship-issue/write-pr/PR template); never hand-roll"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-21T22:07:21.945Z
---

A workflow skill composes sub-skills. `/work-project` means executors run **ship-issue**, which composes **write-pr** (canonical Why / Behavior / Test-plan body + the repo `.github/pull_request_template.md`) and **storybook-stories**. Run those skills — never hand-roll an executor prompt, hand-write a PR body via `gh pr create --body`, or skip the PR template.

I dispatched a hand-written executor prompt and hand-wrote the PR body, ignoring ship-issue/write-pr and the template. Evan: "why the fuck can you not use the goddamn skills baked into the set workflow?! You didn't even use the FUCKING PR TEMPLATE."

**Why:** The skills ARE the conventions — they encode the template, review labels, size checks, and approval gates. Substituting my own judgment discards that and reintroduces the exact drift the workflow exists to prevent.

**How to apply:** When a skill prescribes a sub-skill or template, invoke/follow it verbatim. work-project executors run ship-issue via `~/.claude/skills/work-project/executor-prompt.md`, not a bespoke prompt. PR bodies go through write-pr + `.github/pull_request_template.md` (Why / Behavior / Test plan / opt. Screenshots / opt. Out of scope), shown for approval before overwriting a non-empty body. If a prescribed skill seems wrong, surface it — don't silently substitute.

Related: [[feedback-orchestrator-delegates-execution]], [[feedback-disabled-skill-hand-off-command]], [[thrive-bot-reviews-label-triggered]]

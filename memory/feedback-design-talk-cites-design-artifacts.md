---
name: feedback-design-talk-cites-design-artifacts
description: "When the subject is a workflow's design, evidence comes from docs and the workflow's own files — never from live instances of it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a89e302c-a46a-4827-9e46-f30b6c0fcb4a
  modified: 2026-08-07T19:42:58.157Z
---

Discussing how `/work-project` should adopt GitHub stacks, I probed his repo's live PRs and cited an existing stack (#980, holding #978→#979) as evidence. He cut it off: "I never fucking said anything about the current state of my PRs. We are discussing an UPDATE TO THE WORKFLOW. Stop pulling in things that are not in scope."

**Why:** Scope governs what I *cite*, not just what I *change*. Nothing was edited out of scope — the violation was dragging live production state into a design conversation, which forces him to sort my findings from his ask. Sibling of [[feedback-proposals-cover-named-surface-only]], which covers the change side of the same rule.

**How to apply:** When the subject is a procedure, skill, or workflow, evidence comes from the vendor docs and the procedure's own files (`SKILL.md`, prompts, config). Live instances — open PRs, running sessions, current tickets — are out of bounds unless he names them. If a live fact genuinely changes the design, raise it as its own item after the design is settled.

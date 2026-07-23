---
name: feedback-explicit-directive-overrides-stale-copy
description: "a user's explicit directive is settled; don't re-litigate it against stale artifact copy (project charter, description) — rewrite the copy instead"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1835a6ad-ab07-4c6c-9342-03bd24a8d594
  modified: 2026-07-23T16:08:03.552Z
---

When the user has explicitly directed something — which project the work goes in, which approach, which file — that decision is settled. Do NOT re-open it by weighing it against stale artifact text (a project overview, a "charter", a description). If the existing copy conflicts with the directive, the copy is what's wrong: offer to rewrite it and proceed. Never ask "should we use a different X instead." Read intent contextually, not the artifact literally.

**Why:** Evan (angry): "I told you the work belongs in this project. The 'charter' is some fucking copy. Just re-write it… think contextually instead of literally." He'd named the project in the opening prompt; I treated the project overview's "no refactoring" wording as authoritative over his explicit instruction and re-asked whether to use a new project.

**How to apply:** When a discovered artifact conflicts with a user directive, resolve it by updating the artifact, not by re-questioning the directive. This narrows [[feedback-dont-guess-issue-project]]: that "never attach to an existing project (it redefines scope)" rule applies only when the user HASN'T named a project — an explicit directive overrides it. Related: [[feedback-correction-is-not-a-go-signal]], [[feedback-invoked-skill-defines-deliverable]].

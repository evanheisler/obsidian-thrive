---
name: feedback-backtick-scoped-package-names
description: Bare scoped npm names (@gorhom/bottom-sheet) in published GitHub text @-mention the real account — always backtick them
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca360ef0-3521-4f71-8a69-b3434f7f3e70
  modified: 2026-08-11T19:35:16.173Z
---

A review handler on thrive#1032 wrote `@gorhom/bottom-sheet` bare in PR reply text, which GitHub rendered as an @-mention of the package author's real account — summoning an outside person onto a company PR, repeatedly. Evan: "Tell the fucking executor to STOP TAGGING THE PACKAGE AUTHOR."

**Why:** GitHub parses any `@name` outside a code span as a mention and notifies that account. Scoped npm package names all start with `@`, so every bare reference to `@scope/pkg` in a PR body, review, reply, or commit message pings a stranger. This is the tagging ban ([[feedback-never-tag-evan-in-pr-comments]]) with a wider blast radius — it reaches outside the company.

**How to apply:** In ALL published text, scoped package names go in backticks (`@gorhom/bottom-sheet`) or drop the `@` (gorhom/bottom-sheet). Put this rule in every dispatch prompt for agents that post to GitHub. If a bare mention already shipped, edit the published text immediately to de-fang the link (the notification already fired; the standing link still must go).

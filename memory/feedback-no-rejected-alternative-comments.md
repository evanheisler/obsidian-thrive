---
name: feedback-no-rejected-alternative-comments
description: "Never write code comments narrating why an alternative wasn't chosen; obvious contrast/variant justifications are not allowlist comments"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 728d7897-0a73-47cd-ba19-dd41ef5db2dd
  modified: 2026-08-20T21:10:12.579Z
---

Evan (2026-08-20, PR #1099): a dispatched executor wrote `// Not \`ghost\`: its \`bg-surface-subtle\` is the card root's own fill, so the pill would vanish into it.` — "You might as well say '// Not orange, because nothing in the app is orange'."

**Why:** The repo's comment policy is allowlist-only (API contracts, workarounds with rationale, non-obvious reasoning). "Why I didn't pick X" is reviewer-directed narration; it is obvious from the design system and noise the moment the change merges. Executors produce these while defending choices to the bot reviewer.

**How to apply:** In every executor/handler dispatch prompt, include the comment allowlist and an explicit ban on comments narrating rejected alternatives or restating the visible. When auditing returned work, sweep the diff for comments the PR added and delete any of this shape. Related: [[feedback-no-workflow-comments-in-app-source]].

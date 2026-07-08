---
name: feedback-docs-task-first-for-humans
description: "READMEs are task recipes for a colleague, never spec restatements — \"how do I do X\" and \"what do I do when it breaks\", with real error messages and worked examples"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

On the theme-v2 codegen README (PR #786), Evan rejected documentation written as a spec:
rule notation like "`{group}/default` → `{group}`, mechanical and exception-free" and
contract language. His words: "Stop writing documentation like a fucking computer and
write it how it would help a human. Highlight how to interact with the new system, what
to do when something goes wrong."

**Why:** a README's reader is a teammate with a task ("designer sent new colors",
"generation failed") and zero project history. Restated design decisions and internal
vocabulary ("authoritative", "decision record", rewrite-rule notation) answer none of
their questions; they need numbered recipes, real error-message text mapped to plain
meaning and the fix, and one worked example traced end to end instead of abstract rules.

**How to apply:** structure docs around the reader's tasks (do X step-by-step; when it
breaks, error → meaning → action → who resolves it); ban spec-speak and ticket
references; put a concrete example before any general rule. Second correction (same PR):
docs state **process invariants**, never current-state enumerations — no file counts,
brand lists, or "four today"-style snapshots that go stale on the next upstream change;
the validator's error messages own the current shape. Worked examples with today's names
are fine as illustration, not as shape contracts. Related:
[[feedback-ingest-matches-raw-artifact]], [[feedback-pr-descriptions-short]],
[[feedback-shared-docs-stay-machine-agnostic]].

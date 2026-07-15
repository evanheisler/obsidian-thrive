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

**Re-fired (BH-3270 type-tokens README, 2026-07-14):** an executor wrote per-brand data facts into the README ("Thrive display/h1/h2 share IvyPresto; Kyzatrex resolves the same keys to different DM Sans weights", a per-brand gap table with slot names/values). Evan: "That information has no business in a README." The values live in `index.ts` + the Figma pull; the README must describe the mechanism/how-to and POINT to the source, never duplicate the data (it drifts). When speccing or reviewing executor docs, treat any per-brand family/size/tracking fact in prose as a defect — collapse it to a pointer to the code + Figma artifact.

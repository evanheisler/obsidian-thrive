---
name: vault-skills-are-the-base-layer
description: "Core vault philosophy: OS → context → repo, specificity wins at every layer; vault content is the BASE and anything more local supersedes it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-21T16:43:20.085Z
---

2026-08-21 (write-pr, vault PR #3): an executor declared a vault skill authoritative over a
repo's own `write-pr`; I accepted it. Evan: "the entire expectation of the vault is like any
environment — specificity wins. This is the BASE — a local skill supersedes it, a repo skill
supersedes that, and so on… Not specific to any skill — this is a core philosophy of how the
entire vault works." Established at planning; the spec encodes it as "projection follows the
OS → context → repo hierarchy" (`wiki/agent-os-redesign.md`, D6).

**Why:** The vault composes like environment config: every artifact it ships — skills,
rules, conventions — is the base layer, overridden by anything more local (context, then
repo). The sole standing inversion is global CLAUDE.md's never-submit-reviews rule, which
exists because a review verdict is attributed to Evan personally — an explicit carve-out,
never a precedent.

**How to apply:** Any precedence question between vault content and something more local:
the local one governs, no case-by-case reasoning. Dispatch prompts for skill/rule authoring
carry this. An executor or reviewer inventing a precedence claim is a design fork for Evan
([[feedback-audit-the-premise-not-just-defects]]), not a finding to resolve locally.

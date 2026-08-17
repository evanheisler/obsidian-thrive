---
name: feedback-proposals-clear-the-binding-constraint
description: "A proposal that doesn't clear the binding constraint isn't a proposal; verify mechanisms from primary sources in the same turn, and lead the pitch with the load-bearing mechanism"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-17T19:18:35.680Z
---

Evan (2026-08-14), after a session with four ungrounded proposals/contracts (fabricated light-mode requirement, hearsay GUI-upload workaround, mechanism-less git-branch pitch that didn't fix the actual blocker, unchecked `tokensPkg` contents): "you propose solutions and are prepared to act with no grounding in reality, inadequate research, awful communication skills and just a generally misleading and weak position."

**Why:** Each proposal consumed his time refuting it; one reached a running executor as a fabricated contract line. The common root: solution stated before the mechanism was verified against the constraint that created the problem.

**How to apply:** Before proposing any fix/workaround: (1) name the binding constraint — if the proposal doesn't clear it, don't raise it; (2) verify every mechanism claim from a primary source (grep, vendor doc, package contents) in the same turn it's written — another agent's claim is hearsay; (3) put the load-bearing mechanism in the first sentence of the pitch; (4) issue-contract lines trace to measured facts, never symptom+assumption. Full postmortem: vault `wiki/ungrounded-proposals-postmortem.md`. Related: [[feedback-no-fabricated-evidence]], [[feedback-findings-need-current-evidence-and-harm]], [[feedback-no-unverified-capability-gaps]].

Fifth instance (2026-08-17, coworker via Evan): docs written off the web-session failure prescribed "local Claude Code CLI" as THE requirement. The actual constraint was the mechanism — a *cloud* session has no GitHub authentication; the skills work from any local surface (Claude Code, Claude Desktop). When documenting a constraint, encode the mechanism (what breaks and why), never the surface list observed to work or fail — surface lists overstate and rot.

Sixth instance (2026-08-17): searched one machine's installed skills, found no design-sync source, concluded "no distribution channel exists," and shipped an 8.8k-line PR vendoring Anthropic's converter into thrive — while the DesignSync tool sat in my own session's tool list proving the capability ships with Claude itself. A bounded local search can never prove a platform capability absent; check what the platform ships (own tool list, vendor docs) before vendoring anything. Evan: "1071 was you making yet another error."

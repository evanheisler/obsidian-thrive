---
name: feedback-enforcement-scales-with-model
description: "Guardrails are priced against the model they protect — when a design simplifies, re-price every downstream enforcement/docs contract written against the old complexity before building it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cfb1c4e0-469f-49af-aeab-0d04bd3200bd
  modified: 2026-08-11T19:55:31.679Z
---

BH-3681 / PR #1040 (2026-08-11): the enforcement issue was specced while the navigation
model was still the complex #996-era design (custom lint rule + skill + ADR + glossary +
mirror — five prose surfaces required to "agree with each other"). After the model
collapsed to three declared maps + a seam, I re-aimed the spec's content at declared maps
but kept every enforcement clause. The executor faithfully built +941 lines guarding ~25
lines of behavior. Evan: "HIGHLY over-engineered… 1000 lines of rules, scripts, and prose
to enforce how screens link together. That is not in the spirit of why the issue existed."
Stripped to: plain lint ban + behavior pins + one AGENTS.md section + ~30-line ADR +
minimal skill.

**Why:** enforcement machinery is priced against the failure modes of the model it guards.
When the model got simple, most guarded failure modes ceased to exist, but the spec's
contract still mandated the machinery — so a compliant executor over-builds. The
[[design-iteration-postmortem-bh3680]] rule "price deletion before the second fix" applies
to guardrail specs exactly as to mechanisms.

**How to apply:** whenever a design pivots or simplifies, every not-yet-built issue written
against the old design gets re-priced clause by clause — not just re-aimed. For each
enforcement clause ask: which failure mode does this catch, and does that failure mode
still exist under the shipped model? Cut clauses whose subject vanished. A validated-useful
artifact (e.g. a skill proven RED→GREEN) earns its minimal form, not its specced form.

Follow-up ruling (ADR, same PR): guardrail *prose* defending a decision against
hypothetical re-litigation earns no place at all — "delete it… Why the fuck would an agent
decide to re-architect the navigation without due cause." The recurrence channel must be
real (a measured repeated failure, a live temptation in the code) before prose guarding it
is justified; the merged design plus review is its own defense. Also: my strip pass
*reduced* the ADR and skill instead of asking whether they should exist — reduction is not
re-pricing. And check repo precedent before shipping any first-of-its-kind artifact (the
repo had zero ADRs; the file would have founded a convention nobody chose).
Related: [[feedback-fix-must-pay-for-itself]], [[feedback-audit-the-premise-not-just-defects]],
[[feedback-conventions-before-machinery]].

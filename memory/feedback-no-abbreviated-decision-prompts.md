---
name: feedback-no-abbreviated-decision-prompts
description: Never explain or ask a decision in vocabulary from my own investigation — spell out the full proposal in plain terms, whole reply not just the question
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d50bfc6c-34ce-4daf-ba04-c11f52520403
---

Evan: "Do not conclude with abbreviated contextual information. What the fuck is a CSP?" (2026-07-06, after I asked approval to file a "CSP follow-up issue" without explaining the term or the issue content)

Again, wider scope: "This is a bunch of gibberish to me" (2026-07-15, on a startup-warning diagnosis written in permission-rule semantics — `Write(pattern)` vs `Edit(pattern)` matching, "bare `Edit` covers all file-editing tools", binary-grep evidence — that buried the actual point: four rules meant to block writes to `.env`/secrets had silently stopped working).

**Why:** An explanation that leans on jargon or context only I hold forces Evan to interrogate me before he can decide. It violates "never assume the user did my investigation." Expertise is per-domain: he is a senior product engineer, so app/product vocabulary needs no gloss — but harness, config, and OS plumbing internals are *my* domain, not his, and "treat the user as an expert" does not license that vocabulary.

**How to apply:** Applies to the whole substantive reply, not just the closing question. Expand every acronym on first use; state what the proposed artifact (issue, PR, config change) would actually say/do, and why. Lead with what broke and what it costs him in plain words — put mechanism and evidence (binary strings, rule-matching semantics) below that, or drop it. Every message must be answerable by someone who read nothing but that message. See [[feedback-docs-task-first-for-humans]] for the same instinct applied to docs.

---
name: feedback-mechanical-sequencing-is-not-a-fork
description: "Don't escalate a cross-repo/ordering split with one obvious correct sequence as a decision question — resolve it and proceed"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f31f3ac0-6b6d-43b4-8aa3-ba2cbdf7d81a
---

When a task splits across repos or slices and there's an obvious correct order (producer before consumer, backend marker before the patient app that reads it), that's mechanics, not a design fork. Resolve it yourself and dispatch; don't stop to ask.

**Why:** Evan: "A obviously. Why is this even a question?" — I asked how to dispatch a cross-repo ticket (backend FHIR marker in bionic-health-app before the thrive consumer that reads it) when backend-first was the only coherent ordering. Escalating it wasted a turn and defeated the AFK autonomy of /work-project.

**How to apply:** In /work-project and similar, reserve questions for genuine forks (ambiguous product/scope decisions the human owns). Sequencing a producer→consumer split, choosing the prerequisite to land first, two-PRs-for-one-ticket coordination — decide and go. See [[feedback-resolve-framing-dont-confirm-it]], [[work-project-verify-bot-reviews-yourself]].

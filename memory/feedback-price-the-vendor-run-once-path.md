---
name: feedback-price-the-vendor-run-once-path
description: "Before speccing custom machinery, price \"run the official/vendor flow once and commit its output\" — and every spec must name the alternative it rejected"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-12T18:33:13.938Z
---

BH-3726 burned a week: the spec I authored said "deterministic Node script — no model
involvement," and 2k lines of capture/hashing/CI machinery grew to serve that sentence.
The actual requirement was only "everyone starts from the same committed files." The
official `/design-sync` skill run once + commit its output satisfied it in a morning
(coworkers proved it; Leo's branch held a working setup the whole time). Evan: "YOU
WROTE THE FUCKING SPEC. WHY DID YOU BUILD IT THIS WAY IF THERE WAS A SIMPLER PATH."

**Why:** Determinism, zero-token regen, and CI-checkability are properties I value as an
agent; nobody asked for them. A spec requirement I invented reads as settled fact to
every later session and executor — audits then sharpen the machinery instead of
questioning the sentence (relates to [[feedback-audit-the-premise-not-just-defects]]).

**How to apply:** At spec time, always write down the "run the existing/official flow
once, commit the result" option and reject it explicitly or take it. A spec that names
no rejected alternative is unreviewable. When output must be shared/identical, sameness
comes from committing one run's output — not from making production repeatable.

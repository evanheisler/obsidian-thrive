---
name: feedback-no-negative-claims-from-bounded-queries
description: Never assert non-existence from a truncated listing; alarm-grade findings need the direct targeted query and every contradicting signal reconciled first
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ee815298-b2e4-4113-b993-f0b7d9ec3276
  modified: 2026-08-10T15:37:57.445Z
---

Asserted "no shipped binary carries these runtimes" from `eas build:list --limit 50` (cut off Jul 20; the live 2.2.1 builds were Jul 17) and escalated it into "the production OTA promote reached zero devices / the OTA loop has been dead for 2 weeks." Wrong. `eas build:list --fingerprint-hash <hash>` answered the existence question directly the whole time, and an in-context signal already contradicted the claim: the nightly's `get-build` gate — which fails the run when no matching build exists — was passing daily. Evan had installed the builds himself; the false alarm cost him a panic over production state.

**Why:** A bounded listing proves presence, never absence. And an outage-shaped claim ("prod release was a no-op", "pipeline dead") is the highest-stakes assertion a session can make — it acts on Evan like a pager alert.

**How to apply:** Before reporting any non-existence or outage-shaped finding: (1) run the *targeted* query for the exact entity (filter by hash/id, not a windowed list); (2) enumerate signals that would be impossible if the claim were true (passing gates, user-observed behavior, daily-succeeding jobs) and reconcile every one; (3) if any contradiction is unresolved, report it as an open contradiction, not a conclusion. The design intent question ("is this divergence deliberate?" — e.g. release branches deliberately off main until store release) must be asked before labeling divergence as breakage. Related: [[feedback-no-fabricated-evidence]], [[feedback-cross-check-measurements]], [[feedback-refetch-before-asserting-state]], [[feedback-verify-the-rationale-holds-at-each-site]].

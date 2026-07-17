---
name: hubspot-baa-intake-telemetry-stance
description: "HubSpot sink is under a BAA; the intake telemetry forbidden-props comments were agent-authored during migration, not a compliance ruling; one issue may span thrive + bionic-health-app"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d6f08560-e6bf-4ae0-acf9-5d2fcbf955f8
---

Parked BH-3182 (2026-07-17) over `price_lookup_key`/`product_name`/`dq_reason_details` reaching HubSpot; Evan overruled both blockers.

**Why:** HubSpot is already under a BAA, and other intakes (TRT/GK, in repos not on this machine) already send these properties today. The "never leaves the funnel" comments and FORBIDDEN_TELEMETRY_PROPERTY_KEYS fixtures in `packages/intake` and the bionic-health-app relay were written by the migration agents — code-comment rationale is not automatically a business rule. Separately: there is no precedent for splitting one spec into client + backend tickets; a single Linear issue covering both repos is the norm.

**How to apply:** A documented in-code privacy stance is evidence, not authority — when an issue spec contradicts it, surface the conflict to Evan and take his call rather than parking outright; for this pipeline the call is made (these props are approved under the BAA). Cross-repo producer/consumer work stays under one issue — sequence the PRs ([[feedback-mechanical-sequencing-is-not-a-fork]]), don't split the ticket.

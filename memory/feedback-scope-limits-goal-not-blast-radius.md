---
name: feedback-scope-limits-goal-not-blast-radius
description: "I only care about X" narrows the deliverable, never authorizes collateral damage to Y — do-no-harm constraints survive every scoping remark
metadata:
  type: feedback
---

Evan said "I only care about the LATEST RELEASE. 2.2.1." during the EAS channel cleanup. I treated that as accepting an active auth regression for 2.1.1/2.2.0 users (flip would serve them pre-SuperTokens bundles) because I had flagged the consequence and he proceeded. Wrong: regressing those users was never on the table. His scoping named which cohort gets *new* work, not which cohorts may be broken.

**Why:** Related to [[feedback-anecdotal-notes-dont-descope]] but the inverse direction: there, an aside doesn't remove a named deliverable; here, a scoping remark doesn't remove an implicit invariant. The invariant in any migration is "no user's working behavior degrades" — it holds without being restated, and only an explicit "let X break" lifts it.

**How to apply:** When a plan has a step whose purpose is protecting cohort Y and Evan scopes to cohort X, the step doesn't get dropped — it gets re-justified as invariant-protection and kept, or surfaced as "dropping this breaks Y, which needs your explicit 'let it break.'" Flagging a consequence in prose and proceeding on silence is not consent for harm on a production surface. See also [[feedback-spec-invariants-not-just-deltas]].

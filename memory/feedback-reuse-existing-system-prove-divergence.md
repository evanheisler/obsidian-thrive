---
name: feedback-reuse-existing-system-prove-divergence
description: "Before building anything resembling an existing system, reuse/extend it by default; a parallel implementation needs contract-determined necessity, and a reference POC's ADRs aren't binding"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T19:19:58.658Z
---

Before authoring anything that resembles an existing system — a domain folder, a component, a whole flow — **first grep for the existing same-concern system and default to reusing/extending it.** DRY + extensibility are core. Only deviate where the **contract/requirement determines the divergence necessary** — never by default, and never merely because a reference POC did it that way.

A cited POC (here thrive #885) and its ADRs are a **parts bin + a record of one engineer's choices, not a binding blueprint.** Re-derive every divergence from the wire contract / requirement, and reverse the POC's unjustified deviations. In this session I inherited #885's invented `appointment-booking` domain and its wholesale-duplicated `TimeGrid` + timezone formatters — right next to the existing `components/scheduling/` feature that already *was* a booking wizard. Evan: "Reuse and extensibility are core principles, so keep the code DRY where possible. Only deviate where its been DETERMINED ITS NECESSARY. Not by default. Do your fucking research."

Determined-necessary divergences are *proven*: e.g. `place-order` sends `selected_time` + `alternate_times[]` (cap 3) → multi-select really can't reuse a single-select picker. Unjustified ones are duplication dressed up as design: a parallel domain for the same concern; forked formatters that differ only by a timezone *parameter*.

**Why:** parallel implementations of one concern rot independently and multiply maintenance. A POC's job is to prove the API works, not to set the architecture.

**How to apply:** new domain/component/flow → grep the codebase for the concern-owner first, reuse/extend it, and justify each divergence against the contract. Treat reference-POC structure (and its ADRs) as disposable. "Research" = read the existing system + the wire contract before proposing structure.

**Orchestrator enforcement (executors don't do this on their own):** executors repeatedly re-implement things that already exist — the `date-mask.ts` copy of MWL's `validateDobDigit`/`DOB_PATTERN`, the whole `appointment-booking` domain, `LocationList` vs `OptionCard`, `AddressForm` buried in scheduling instead of `ui/`. Evan caught each one; I shipped them because I trusted the executor's DRY judgment. **Do NOT.** Before a slice is treated as reviewable, run a reuse audit on its output: for every new file/symbol/helper the slice introduces, grep the repo (other `apps/*`, `packages/*`, `components/ui/*`, `utils/*`, `@repo/*`, sibling features) for a pre-existing equivalent, and collapse the copy. Relying on Evan to find each dupe is the recurring failure — Evan: "You fucking suck at writing DRY, reusable code."

Related: [[feedback-extract-mechanism-not-whole-model]], [[feedback-domain-by-concern-not-screen]], [[feedback-no-single-use-abstractions]], [[feedback-patterns-mean-whole-codebase]]

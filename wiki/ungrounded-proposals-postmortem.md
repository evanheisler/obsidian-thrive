---
title: Ungrounded proposals postmortem
summary: 2026-08-14 design-workflow session — four proposals/contracts offered before verifying they were real or that they cleared the binding constraint
last_updated: 2026-08-14
---

# Ungrounded proposals postmortem

One session, four instances of the same failure: **stating a solution or requirement
before verifying the mechanism, from a primary source, against the constraint that
created the problem.**

## The instances

1. **Fabricated requirement.** Wrote "light mode presentation" into BH-3858's contract,
   inferred from a wrong-colors screenshot. `DEFAULT_THEME_MODE = 'dark'`
   (`apps/patient/theme/theme-mode.ts:9`) was one grep away. An executor built against
   the fabricated line until corrected mid-flight.
2. **Hearsay as workaround.** Relayed another agent's "create the design system by hand
   in the Design systems tab" as the interim designer path. That agent had fabricated a
   UI detail ("export menu") in the same reply. Anthropic's own docs — one WebFetch —
   show GUI upload is *generative* (Claude reinterprets assets; "Remix" chat for
   updates), never a verbatim mirror. The workaround produced a different artifact, not
   the design system.
3. **Mechanism-less pitch that didn't clear the constraint.** Proposed "publish the
   bundle to a git branch" across three turns without stating the load-bearing mechanism
   (release assets ride the API transport the web sandbox blocks; branch files ride the
   git transport the sandbox already uses) — and without flagging that it bought nothing
   anyway: the binding constraint was the DesignSync *upload*, still broken on web.
4. **Unchecked package contents.** BH-3726's config pointed `tokensPkg` at
   `@repo/tokens` without checking what CSS that package ships against what the patient
   app consumes. Its only stylesheet is the EHR-legacy `brand.css` → the EHR palette
   rode into the patient design system.

## The tests (generative, not verdicts)

- **Name the binding constraint first.** If the proposal doesn't clear it, it is not a
  proposal — it's motion. (The branch idea failed this test; the fetch was never the
  blocker.)
- **Mechanism claims are verified from a primary source in the same turn they're
  written.** Grep the code, fetch the vendor doc, read the package. A claim relayed from
  another agent or inferred from a symptom is hearsay until verified — repeat it only
  with the flag, or verify it first.
- **The pitch leads with the load-bearing mechanism.** If the one fact that makes the
  option work isn't in the first sentence, the listener cannot evaluate it and the
  proposal is noise.
- **Issue contracts trace every requirement to a measured fact.** A symptom
  (screenshot) plus an assumption is not a requirement when the source of truth is
  greppable.

Related: [[research-first-endstate-postmortem]] (analysis-side of the same disease),
[[work-project-orchestration-postmortem]].

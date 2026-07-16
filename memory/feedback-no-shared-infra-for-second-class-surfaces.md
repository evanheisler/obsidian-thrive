---
name: no-shared-infra-for-second-class-surfaces
description: "Never extend shared/production layers (packages/tokens, runtime vars, public APIs) to serve a dev-tool surface like Storybook; fix the bug inside the surface that has it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Never codify legacy support into a shared production layer to appease a second-class surface. PR #841 (BH-3310) fixed a Storybook-only preview bug (two legacy utilities not following the Brand toolbar) by extending `packages/tokens`: a new `LEGACY_FONT_WEIGHTS` export, new `--type-ff-*` runtime vars emitted for every `typeVariables()` consumer including the patient app, a new public `tailwindLegacyFontFamily()` API, README section, and tests. Evan: "absolutely insane… Storybook is a second class citizen at best. There is ZERO PRECEDENT for codifying legacy support across the app just to appease a runtime 'nice to have'."

**Why:** Deprecated constructs being migrated off must never gain first-class infrastructure — that aliases the old world into the new layer ([[theme-v2-deprecate-non-figma-tokens]]) and makes their eventual deletion an API unwind instead of a file delete. And a dev/preview surface (Storybook, catalogs, tooling) must never tax production consumers: if app runtime code carries new vars/exports that exist only so a preview looks right, the fix landed in the wrong place.

**How to apply:** Fix a bug inside the surface that has it — a Storybook rendering gap gets solved in `apps/storybook-patient` (local vars in its own decorator/config), never in `packages/*`. Before touching a shared package, ask: who pays for this surface, and does any production consumer need it? If the only beneficiary is a second-class surface, or the beneficiary is a legacy construct on its way out, the shared-layer change is forbidden — contain it or park it. Check executor/PR output for this pattern; it is a rework trigger, not a nit. Related: [[feedback-no-single-use-abstractions]], [[feedback-theme-tailwind-axes-not-custom-utilities]].

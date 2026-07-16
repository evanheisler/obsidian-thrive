---
name: typography-lockstep-end-state-zero-legacy
description: "The Typography System — Figma Lockstep project's outcome is ZERO legacy typography styles, overrides, or misleading abstractions anywhere; specs that preserve legacy utilities are mis-scoped"
metadata: 
  node_type: memory
  type: project
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Evan (2026-07-16): the outcome of the Typography System — Figma Lockstep project "should be NO LEGACY STYLES, OVERRIDES, or generally misleading abstractions or styles exist anywhere related to typography. This project MUST get in lockstep with the design spec and actively block misuse and custom styles."

**Why:** Several project tickets encoded the opposite premise — BH-3310 asked to var-back `font-body-semi`/`font-body-extrabold` for Storybook, BH-3311 ordered legacy family-class sites left as "cosmetic churn," BH-3312 keeps 177 legacy class names silently re-pointed via a config-spread collision. Executing those briefs literally converges on "legacy aliased to spec," not "legacy gone." An issue brief that preserves or supports a legacy typography construct is itself wrong, not a mandate ([[no-shared-infra-for-second-class-surfaces]]).

**How to apply:** Churn-minimization is not a scoping reason here — "no output change, migrating is cosmetic churn" is exactly how legacy names survive; a legacy name is a defect even when it renders correctly. When authoring or executing issues in this project, the deliverable is deletion + clean slot implementation: no abstractions, no extensions, no aliases. Never add code (previews, vars, font-face registrations, config keys) that supports a legacy typography utility — the correct move is deleting the utility and migrating its sites to `<Text variant>` slots, or parking for a scope call. Legacy family utilities (`font-body-semi`, `font-body-extrabold`, and ultimately `font-body-bold`, `font-display`, the legacy tailwind fontFamily keys) are deletion targets, not support targets. The lint should end at error/block, not warn. When a ticket brief conflicts with this end state, surface the conflict instead of executing it. Related: [[theme-v2-deprecate-non-figma-tokens]].

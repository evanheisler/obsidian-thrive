---
name: ehr-color-system-never-backported
description: "EHR predates the TS theme system and consumes packages/tokens/brand.css (legacy CSS vars, hardcoded dark) — theme/token work in packages/tokens/themes cannot affect it"
metadata: 
  node_type: memory
  type: project
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

The patient-app theme system (`packages/tokens/themes/*`, `palettes/*`, consumed via the patient/storybook tailwind configs) came after the EHR and was never backported (confirmed by Evan, 2026-07-06). The EHR imports `@repo/tokens/brand.css` in its `globals.css` — its shadcn class names (`bg-popover`, `border-input`, `card-foreground`) resolve to CSS variables defined there, a parallel vocabulary that still contains non-v2 token names.

**Why:** token deletions/renames in the TS theme layer (e.g. theme v2 alignment, [[theme-v2-deprecate-non-figma-tokens]]) are isolated from the EHR — but "unaffected" means isolated, not aligned.

**How to apply:** when changing `packages/tokens`, check whether the change is in the TS theme layer (patient-only) or `brand.css` (EHR); don't claim EHR impact either way without checking which file. If v2 alignment is ever extended to the EHR, `brand.css` is where the deprecation exercise happens.

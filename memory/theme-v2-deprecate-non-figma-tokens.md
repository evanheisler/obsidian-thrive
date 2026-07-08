---
name: theme-v2-deprecate-non-figma-tokens
description: "Theme v2 directive — tokens absent from the Figma v2 styleguide are deleted, never aliased; consumers migrate to v2 semantic names"
metadata: 
  node_type: memory
  type: project
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

For the Configurable Theme mode project (theme-v2 branch), Evan's directive is that code must use **only the semantic token names that exist in the Figma v2 styleguide**. Tokens the v2 spec dropped (`popover`, `secondary`, `highlight`, `input`, `card-foreground`, `card-primary`, `neutral-foreground`, etc.) are **deprecated and removed** — not kept alive by re-pointing their values at v2 ramp steps.

**Why:** the goal is code↔design alignment by name, so designers and engineers share one vocabulary. Aliasing preserves drift.

**How to apply:** when migrating a dropped token, use its value analysis only as a guide to which v2 token each *consumer* should switch to, then delete the token from `ThemeCoreTokens`/brand files. Never propose "map old token → new value" as the fix. (Correction given 2026-07-06 after I proposed exactly that.)

Second correction (same day): don't classify a dropped-token migration as "needs design". A token absent from the guide was never designed — there is no design answer to wait for. Engineering picks the nearest v2 token per consumer and the launch visual sign-off (BH-3130 reviews every screen, both brands, all platforms) is the design review gate. Blocking on a designer Q&A double-gates. Design asks are only for colors that need a *new* swatch authored (e.g. the AI Assistant violet).

**Authority inversion (2026-07-08, "We are not the authority. Full stop."):** the design system (Figma Variables: Color + Primitives collections) is authoritative in name AND value, and **complete by definition** — the designer built the whole UI with it. Never frame differences as "design is missing N tokens" or queue designer to-dos; a code reference that can't be expressed in the theme is flagged and solved in realtime (it's a re-map or an illegitimate usage). A11y included: AA failures in design values route to the designer via the KNOWN_FAILURES ledger (**soft gate** — migration/launch never blocks on it, code never adjusts a value). Naming: mechanical flatten of variable paths, no exceptions (`{group}/default`→`{group}`, `{group}/{step}`→`{group}-{step}`, drop `system/`) — renames `primary`→`brand`, `background`→`surface` app-wide. Values extracted via designer JSON export (artboard rebind is a follow-up).

**Broader principle (2026-07-07, "I shouldn't have to keep emphasizing this"): the project is ELIMINATING CODE OVERRIDES — design and code in lockstep.** Every color the app renders is a defined Figma variable; code computes/derives nothing. This killed `contrastSafeFill` + `STATUS_DEFAULTS` in `build-theme.ts` (BH-3144 rewritten: delete the solver, don't fix its clamp bug — status bases and `*-fill`s become authored per brand×mode). AA safety comes from the contrast test suite as a CI gate (author → verify), never from a code-side solver (derive → trust). Apply this lens to any future proposal: if code adjusts, computes, or falls back on a color value, it's wrong — the fix is a defined value in Figma. Source of truth is the Figma Variables semantic collection (the styleguide artboard frames were declared the designer's process work, 2026-07-07); see [[feedback-figma-access-is-evans]] for file access.

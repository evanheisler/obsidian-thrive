---
name: feedback-theme-tailwind-axes-not-custom-utilities
description: "Design-system values go INTO Tailwind's native theme axes; components are baskets of real Tailwind classes — never a parallel custom-utility namespace"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e9f020b-03bd-416a-b1ca-cb38e9f58b92
---

BH-3227's type layer shipped custom plugin utilities (`font-type-h1`, `case-type-h1`) alongside the themed `fontSize` scale, so an h1 required three classes from two paradigms. I proposed fixing it with MORE custom composite utilities (`.type-h1`). Evan closed PR #823 over the design and rejected the proposal: "You are basically saying 'pave over the tailwind utilities with new custom utilities'. We cannot eliminate the use of tailwind, so your solution codifies different styling paradigms. Why wouldn't the solution be to map tailwind utilities to the design spec, and the Text variant abstraction is a basket of actual tailwind classes. This is literally the core mechanics of how to modify tailwind/nativewind."

**Why:** Tailwind can't be eliminated from the codebase, so a custom utility namespace means two styling paradigms forever. Theming Tailwind's own axes (fontSize, fontFamily, letterSpacing…) makes standard Tailwind vocabulary express the design spec, and component variants stay ordinary class baskets any dev can also write by hand.

**How to apply:** When encoding design-system values, put them in Tailwind's native theme scales and compose variants from real utility classes (cva-style). A `plugin(addUtilities)` call for something Tailwind already has an axis for is the red flag. Check executor output for parallel utility namespaces like [[feedback-no-single-use-abstractions]].

**Cross-brand axes — per-slot keys, always emitted, values coincide or diverge:** when two brands group a native axis differently (Thrive display/h1/h2 = one serif; Kyzatrex = three DM Sans weights), do NOT conclude "one utility name can't map both brands" and treat it as a design fork needing the human. The mechanism is trivial and forced: add a **per-slot key** to the native axis (`fontFamily: { h1: 'var(--font-h1)', h2: 'var(--font-h2)' }`), always emit it in the variant basket, and let the brand's CSS-var VALUES coincide in one brand (`--font-h1` == `--font-h2` == IvyPresto) and diverge in another (`--font-h1` = DMSans-SemiBold, `--font-h2` = DMSans-Medium). The variant→classes map stays brand-agnostic; only the var values differ — same shape the color system already uses. Slot-named native-axis keys (`font-h1`, `tracking-h1`) are NOT the rejected `font-type-*`: those were `addUtilities` composites + a custom `text-h1` size key; these are plain native-axis utilities and size stays on the standard t-shirt scale. Evan surfaced this himself ("why can't font always be declared, but in Thrive they happen to be the same, and in Kyzatrex they differ?") after I over-escalated it as a fork — resolve the mechanism, reserve the question ([[feedback-resolve-framing-dont-confirm-it]]).

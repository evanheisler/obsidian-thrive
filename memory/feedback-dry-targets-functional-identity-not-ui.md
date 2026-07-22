---
name: feedback-dry-targets-functional-identity-not-ui
description: "A reuse/DRY audit targets functionally-identical logic (parse/convert/validate/format pure functions, constant lists), never visual or structural UI similarity; a prop-driven component that needs per-consumer key/label injection is over-abstraction, not sharing"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T20:45:10.504Z
---

The DRY/reuse target is **functional identity** — pure logic that is byte-identical regardless of surface: phone parse/format, ft/in↔inches conversion, zod validation fragments, a state-options list. Share those. **Visual or structural similarity of UI is NOT a dedup signal.** Two forms/screens that look alike each render their own markup; you share the pure functions they both call, you do **not** extract their layout into a shared component.

The anti-signal, exactly as Evan named it: a "shared" component that is fully prop-driven yet still needs each consumer to inject **different field keys** (`weightLb` vs `weightPounds`) plus labels/units/testIDs is not one shared thing — it's two different forms wearing a shared shell, and the parameterization is more code and worse than inlining. This session I over-scoped a height/weight dedup into a `HeightWeightFields` mini-form; the field-key escape hatch was the tell. Evan: "the DRY audit was for FUNCTIONAL IDENTICAL CODE. i.e. parsing a phone number… Why did you create this mini-form that is completely prop-driven but still allow for variations in field key for some stupid fucking reason?"

**Why:** a leaky, over-parameterized component rots worse than the duplication it "removes" and couples unrelated forms. UI similarity is coincidental; functional identity is structural. (Distinct from *using* an existing generic `ui/` primitive like `OptionCard`/`Input` — that's fine; the error is *extracting a new bespoke composite* to span two specific forms.)

**How to apply:** scope every reuse audit/extraction to pure functions + validation + constant lists only. When two forms share a look, extract the pure helpers they both call and **inline the markup** in each. If a proposed shared component needs per-consumer key/label injection, that's the stop sign — don't extract it. Relates to [[feedback-no-single-use-abstractions]], [[feedback-reuse-existing-system-prove-divergence]].

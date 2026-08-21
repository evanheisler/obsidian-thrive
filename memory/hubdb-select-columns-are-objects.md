---
name: hubdb-select-columns-are-objects
description: "HubDB select/option columns serialize as {id,name,label,type:'option'} objects, not strings — medication_coverage is one; read .label"
metadata: 
  node_type: memory
  type: project
  originSessionId: 728d7897-0a73-47cd-ba19-dd41ef5db2dd
  modified: 2026-08-21T15:07:00.382Z
---

Proven live (2026-08-21, PR #1099 crash): the HubDB `medication_coverage` column in the thrive-products table is a **select** column, so `row.values.medication_coverage` arrives as `{ id, name: "medication_included", label: "Medication included", type: "option", ... }` — not a string like the rich-text `payment_coverage_text`. Passing it to `htmlToPlainText` threw `html.replaceAll is not a function` inside TanStack Query's `select`, which surfaces as the generic query-error UI ("Something went wrong") with a 200 API response and no red box. Read `.label` (display copy); never fall back to `.name` (snake_case slug). Typed as `HubDatabaseOption` in `packages/hooks/src/products/hubdb-types.ts`.

**Lesson:** never assume a new HubDB column shares a neighboring column's serialization — fetch a real row before writing the transform. Fixture-driven tests all passed while the app crashed: [[feedback-tests-must-cross-the-runtime-boundary]].

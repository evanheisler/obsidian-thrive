---
name: storybook-entries-are-earned-not-migrated
description: "A legacy story file is not proof its component deserves a sidebar entry — the reorg's objective is a curated design-system catalog, not a 1:1 conversion"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-10T16:01:34.197Z
---

During the Storybook reorg (BH-3760–3769), executors converged every legacy story file in their scope lists 1:1 — including `BiomarkerFilters`, a thin implementation of `FilterDropdownButton` that Evan never wanted as a story or component entry at all. The placement debate that followed (Components/ vs Patterns/) was friction over a story that should not exist.

**Why:** The sidebar is the Claude Design workflow's working surface — a curated catalog of real, reusable design-system subjects. Legacy stories do not carry the semantics the repo is moving toward; a scope list of existing files is an inventory of *files to process*, not of *subjects that earn entries*. A wrapper, usage, or shim of an existing `Components/` entry folds into that entry's docs page or is deleted — it never gets its own entry, and its placement is never worth deciding.

**How to apply:** In every reorg/story dispatch prompt, state the objective, not just the shape rules: "entries are earned — if the component is a wrapper/parametrization of an existing entry, fold or delete its story and say so in your return; do not converge it." When a placement question produces friction, first ask whether the subject should exist at all. Related: [[feedback-current-shape-is-not-a-requirement]], [[feedback-dry-targets-functional-identity-not-ui]].

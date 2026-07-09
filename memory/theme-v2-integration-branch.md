---
name: theme-v2-integration-branch
description: "The Configurable Theme mode Linear project integrates on the theme-v2 feature branch, not main — base PRs there"
metadata: 
  node_type: memory
  type: project
  originSessionId: ef8efea5-1e2c-4f40-86fd-db7e645971f7
---

The **Configurable Theme mode** Linear project (patient app) integrates onto the long-lived `theme-v2` git branch in `thrive`, **not** `main`. Every project PR bases off and merges into `theme-v2` (BH-3211 #789, BH-3210 #786, BH-3202, BH-3200, BH-3172, BH-3145, BH-3129 all merged to `theme-v2`).

**Why:** The generated design-system tokens (e.g. the `system-blue` scale) exist only on the `theme-v2` line. An issue based off `main` won't find them and will misdiagnose the tokens as absent.

**How to apply:** When shipping any issue in this project, base the worktree and PR on `theme-v2` (`nwt <slug> theme-v2`, `gh pr create --base theme-v2`). The public launch (BH-3130, human-led) is the eventual `theme-v2` → `main` gate. Don't assume `main` for theme work — verify the project's integration branch first.

Related: [[theme-v2-deprecate-non-figma-tokens]], [[token-map-by-color-not-role]], [[ehr-color-system-never-backported]].

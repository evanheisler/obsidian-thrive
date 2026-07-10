---
name: theme-v2-integration-branch
description: "theme-v2 merged to main via PR #796 (2026-07-10) — theme work now bases on main; generated tokens are on main"
metadata: 
  node_type: memory
  type: project
  originSessionId: ef8efea5-1e2c-4f40-86fd-db7e645971f7
---

The **Configurable Theme mode** project's long-lived `theme-v2` integration branch **merged to `main` on 2026-07-10** via PR #796 ("Configurable theme mode: generated design-system tokens (theme v2)"). The generated design-system tokens (e.g. the `system-blue` scale) now exist on `main`.

**How to apply:** Theme-mode work now bases worktrees and PRs on `main` like everything else. Any branch created before 2026-07-10 that predates #796 must rebase onto fresh `origin/main` before opening a PR (it's a large diff — check for token interactions in preflight). The historical pattern (PRs #789, #786, etc. based on `theme-v2`) no longer applies.

Related: [[theme-v2-deprecate-non-figma-tokens]], [[token-map-by-color-not-role]], [[ehr-color-system-never-backported]], [[feedback-worktree-base-must-be-fresh-origin]].

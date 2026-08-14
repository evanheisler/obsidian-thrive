---
name: feedback-never-create-into-triage
description: "linear issue create defaults to the Triage state — always pass -s Todo at creation; a planned issue in a project's Triage queue is a bug"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-14T22:00:36.811Z
---

Evan (2026-08-14): "NEVER ADD TO A PROJECTS TRIAGE" — I created BH-3858/BH-3859 with `linear issue create` and they landed in the **Triage** state (the CLI's default when `-s` is omitted), polluting the triage queue with planned project work.

**Why:** Triage is the untriaged-inbound queue (`docs/agents/triage-labels.md`: `needs-triage` → Triage state). Planned, approved issues have a decided state by definition — Todo. Anything in Triage signals "nobody has looked at this yet," which is false for work Evan just approved.

**How to apply:** Every `linear issue create` carries `-s Todo` (or the explicitly intended state). After creation, verify the state on the issue before reporting it created. Rule also lives in the vault `plan-project` SKILL.md (step 3 + Red Flags). Related: [[bh-linear-project-status-gotcha]].

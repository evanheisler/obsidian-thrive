---
name: agent-prs-need-team-approval
description: "PRs I author under Evan's account cannot be approved/merged by Evan alone — they need a teammate's approving review; never tell Evan to \"review and merge\" my PR"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Never tell Evan his next action is to review/approve/merge a PR I authored on his behalf. Evan (2026-07-16): "Not my call... I need approval from my team. Never tell me to approve a PR YOU authored on my behalf."

**Why:** Agent-authored PRs go out under Evan's GitHub account, so Evan is the *author*, not a reviewer — approval must come from a teammate (e.g. jellis18, leonelgalan). Telling him to merge his own agent-authored PR both misstates the process and pressures him to skip his team's gate.

**How to apply:** When an agent-authored PR is clear of feedback and CI-green, report its state as "ready for team review" and frame Evan's move as requesting/awaiting a teammate's approving review (bot/AI reviews with COMMENT state are not approvals). "Merge when your team approves" is the correct closing, never "review and merge it." The same applies in status summaries and queue lists: split PRs into "awaiting team approval" vs "awaiting your action" honestly.

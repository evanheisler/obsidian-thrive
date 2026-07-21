---
name: feedback-verify-branch-protection-before-blocker
description: Never claim a branch-protection merge blocker without reading the actual protection config
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9e04ebff-d053-4fba-80a5-e9057402acb4
  modified: 2026-07-21T20:43:35.148Z
---

Before telling Evan a PR needs a branch-protection / required-status-check change (an "admin action" merge blocker), read the real config: `gh api repos/OWNER/REPO/branches/main/protection --jq '.required_status_checks'`. A 404 on `/protection/required_status_checks` (or `required_status_checks: null`) means NO required checks exist — nothing to "repoint," nothing blocks CI-wise. thrive `main` (2026-07): 1 required review, `required_status_checks: null`.

**Why:** I couldn't read the ruleset earlier, so I *assumed* required matrix checks existed and told Evan to "repoint branch protection to require tests-passed" as a merge blocker needing admin access. It was fabricated — there were no required checks. Inventing an unverified blocker sends Evan chasing a non-problem.

**How to apply:** "can't read X" ≠ "X is a blocker." Fetch the authoritative config or say "couldn't verify, so unknown" — never manufacture a required action from an inability to check. Related: [[feedback-no-unverified-capability-gaps]], [[feedback-refetch-before-asserting-state]], [[feedback-no-fabricated-evidence]].

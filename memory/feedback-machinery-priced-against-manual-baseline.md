---
name: feedback-machinery-priced-against-manual-baseline
description: "Streamlining a working manual process — total machinery cost must stay below the manual baseline, re-priced every round; green CI is not confidence, only the end-to-end proof run is"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-17T21:38:32.618Z
---

2026-08-17, design-workflow correction round: Evan — the manual export to Claude Design "already worked... without an extra 10k lines of scripts and docs"; the project was supposed to streamline it, took a week of planning plus three revision rounds, and "still is unproven. THAT is why I fucking hate you."

**Why:** When the mandate is to streamline an existing working process, the baseline is the manual cost (an upload, a copy-paste). Every mechanism added — including fixes to defects I introduced — raises the total, and fixing my own defect with more machinery is not progress against that baseline. Three correction rounds each audited the implementation; nobody (me) re-priced the premise. See [[design-iteration-postmortem-bh3680]] pattern and [[feedback-fix-must-pay-for-itself]].

**How to apply:** At every correction round on workflow/tooling machinery, before building the fix: state the running total (lines, sessions, hours) against the manual baseline it replaced, and say plainly whether it still pays. If it doesn't, the premise goes to Evan for the knife, not another round. Never claim confidence from green CI or structural argument — the only proof for a workflow is its end-to-end run at a cost the owner would pay again.

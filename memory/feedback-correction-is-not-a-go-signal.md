---
name: feedback-correction-is-not-a-go-signal
description: "A factual correction of my status report is context, not authorization — never take new orchestration actions (dispatch, claim) from it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

During /work-project, Evan corrected my stale status ("nothing is polling, no bot review in flight"). I treated the correction as a resume trigger and dispatched the next executor. He stopped it: "I did not tell you to resume work."

**Why:** an earlier /work-project authorization doesn't survive the user taking the wheel — once they're actively reviewing PRs and correcting my state, dispatch pacing is theirs. A correction turn is "providing context": acknowledge, update the ledger, wait.

**How to apply:** after a user correction or interruption in orchestrated work, the only permitted actions are re-deriving state and reporting it. New claims, dispatches, or writebacks need an explicit go ("continue", "dispatch the next one"). When unsure whether a message is context or a command, it's context.

---
name: no-arbitrary-backoff
description: "When resuming a crashed subagent is idempotent and cheap, retry immediately — never invent multi-minute backoffs that stall the loop"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Don't park crashed-but-resumable work behind invented wait timers. During an API-overload streak (2026-07-16) I escalated 3→10-minute backoffs before resuming subagents; Evan: "why are you waiting 10 minutes" — there was no reason.

**Why:** A resume costs one API call and re-derives state from disk (worktree, commits), so a failed retry loses nothing. The wait, by contrast, is guaranteed dead time on the critical path. Backoff only makes sense when retries themselves are costly or rate-limited — and my own in-session requests succeeding is direct evidence capacity exists for a retry.

**How to apply:** On a transient subagent failure (529s, timeouts), resume immediately. If several consecutive immediate resumes die, a short wait (~1–2 min) is defensible — state the actual reason, not a doubled number. See [[feedback-instrument-dont-use-evan-as-sensor]]: check whether my own requests are flowing before assuming the API is unusable.

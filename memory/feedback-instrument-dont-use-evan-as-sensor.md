---
name: feedback-instrument-dont-use-evan-as-sensor
description: "Debugging means gathering evidence with my own instrumentation; never hand Evan \"try this, what do you see\" loops"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 85ffd638-d8e1-4430-900f-20f173f9cc9d
---

During the emulator sign-in debugging (2026-07-16), I cycled through plausible fixes and asked Evan after each one ("are you signed in now?"). He shut it down hard: "Stop telling me to do things when you are clearly pulling it out of nowhere... you just keep handing me 'what about now' nonsense."

**Why:** Each guess-and-ask round costs Evan a context switch and hides that I haven't found the root cause. The device, logs, and filesystem were all readable by me the whole time — logcat, temporary console.warn instrumentation via fast refresh, `.expo` state files, process lists. Evidence I can collect myself is never his job.

**How to apply:** On any failure, run [[systematic-debugging]]-style evidence gathering BEFORE proposing an action: instrument the failing surface (temp logs + fast refresh on RN), read device/process/file state, and only involve Evan for observations that are physically his (what he sees on a FLAG_SECURE screen, credentials). A question to Evan is a last resort, not a verification step. Related: [[feedback-refetch-before-asserting-state]], [[feedback-no-fabricated-evidence]].

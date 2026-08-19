---
name: feedback-verify-subagent-blockers-before-relaying
description: "A subagent's claimed environment blocker gets validated against known machine state before it reaches Evan — and never relay a blocker my own dispatch manufactured"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 075aa822-a798-4b6d-8bf8-bd47af28acfc
  modified: 2026-08-19T20:30:21.186Z
---

During BH-3472 (2026-08-19) an executor reported "no usable Android emulator" and I relayed it to Evan as an environment blocker. The machine's `Pixel_10` AVD was fine — my dispatch had hardened the disk-fill caution ([[android-emulator-play-store-disk-fill]]) into "never Play Store images", making the only existing AVD forbidden. Evan: "What the fuck are you talking about not being able to start the Android emulator?"

**Why:** two compounding failures — (1) a caution encoded as a prohibition in the dispatch prompt removed the executor's only recovery path; (2) at relay time I had the memory stating Pixel_10 is Evan's in-use AVD and didn't cross-check the claimed blocker against it.

**How to apply:** dispatch prompts carry preferences with fallbacks, never bans, unless the ban is Evan's own rule. When a subagent returns a blocker, check it against what the session already knows (memories, earlier fetches) — if my own instruction created it, fix the instruction and resume the agent; only a blocker that survives that check goes to Evan.

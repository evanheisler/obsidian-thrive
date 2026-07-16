---
name: feedback-validate-the-instrument-first
description: "adb input-tap injection is unreliable on SurfaceView/FLAG_SECURE screens; validate the test instrument against a known-good control before diagnosing \"broken\" product behavior"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 85ffd638-d8e1-4430-900f-20f173f9cc9d
---

Chased a "lobby buttons dead on Android" bug for an hour (2026-07-16) through eight eliminated hypotheses — while Evan, clicking the same emulator with a mouse, had working buttons the whole time (joined the call, used mute/camera/layout). Every failing observation came from `adb shell input tap`; injected taps are flaky on the patient app's video screens (SurfaceView camera preview + FLAG_SECURE window), landing ~1 in 10.

**Why:** an unvalidated instrument turns harness noise into phantom product bugs. The "intermittent touch delivery" signature (some taps land, most vanish, system dispatch looks fine) is what injection flakiness looks like from inside.

**How to apply:** before diagnosing interaction failures observed through `adb input tap`/`uiautomator`, validate the instrument on the SAME screen against a control that must work (or ask Evan for one human tap — that's an observation only he can make, per [[feedback-instrument-dont-use-evan-as-sensor]]'s own exception). Divergence between injected and human input IS the finding. Related: [[feedback-cross-check-measurements]].

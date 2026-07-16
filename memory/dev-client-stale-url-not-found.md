---
name: dev-client-stale-url-not-found
description: Expo dev-client persists its last-opened server URL and re-fires it as the initial URL every launch; expo-router routes it to +not-found; fix = pm clear + reopen with encoded URL
metadata: 
  node_type: memory
  type: project
  originSessionId: 85ffd638-d8e1-4430-900f-20f173f9cc9d
---

Patient dev builds (expo-dev-client, SDK 55): every cold launch landed on "This screen does not exist" (2026-07-16). Diagnosed by adding a temp `console.warn(usePathname())` to `app/+not-found.tsx` (fast refresh delivers it instantly) — pathname was `/expo-development-client` with `params.url=http://192.168.86.150:10002`, a stale Metro address persisted by the dev launcher's "recently opened" list.

**Mechanism:** the dev client re-fires its persisted launch URL as the app's initial URL on every cold start. expo-router's filter for these (`extractPathFromURL` fork, `url.hostname === 'expo-development-client'`) misses when the `?url=` param is unencoded/custom-scheme-parsed, so the URL becomes a literal route → +not-found.

**Fix recipe:** `adb shell pm clear com.bionichealth.members`, restart Metro from the right worktree, then `adb shell am start -a android.intent.action.VIEW -d "'patient://expo-development-client/?url=http%3A%2F%2F10.0.2.2%3A10001'" com.bionichealth.members` (scheme is `patient`, NOT the package; percent-encode the url param). Verify with a plain launcher cold start + logcat.

**Related gotchas from the same session:**
- A `expo start` process existing does NOT mean Metro is serving — it stalls at a port-in-use prompt with no listener. The device's okhttp error (ECONNREFUSED in the dev-launcher error screen) is ground truth.
- This sandboxed shell cannot probe host TCP ports: `curl`/`lsof` get permission-denied and `/dev/tcp` probes always report closed (verified false-negative against adb's 5037). Verify connectivity from the device or the server's own logs instead.
- The patient app's activity is FLAG_SECURE — `adb screencap` returns black. The dev launcher's error activity is NOT secure and can be screenshotted.
- Warm deep-link delivery to the running app misses `useURL()` (BH-3330); cold delivery via launch intent works but races the dev-client bundle load.

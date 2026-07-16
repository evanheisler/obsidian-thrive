---
name: android-emulator-play-store-disk-fill
description: Play Store emulator images self-fill /data with Google app auto-updates until APK installs fail; use Google APIs images for thrive dev
metadata: 
  node_type: memory
  type: project
  originSessionId: 85ffd638-d8e1-4430-900f-20f173f9cc9d
---

Android "Google Play" system images auto-update ~25 stock Google apps into the AVD's /data partition (default 6 GB), eventually failing `adb install` with "Requested internal only, but not enough space" (hit 2026-07-16 with the 143 MB patient debug APK). `pm trim-caches` does NOT help — the space is installed APKs + dexopt, not cache.

**Recovery on a full AVD:** `adb uninstall <pkg>` the updated Google apps (youtube, chrome, maps, photos, youtube.music, docs, gm, googlequicksearchbox, messaging, calendar) — reverts them to factory versions in the system image; freed ~1.1 GB.

**Prevention:** use a "Google APIs" (non-Play-Store) system image for dev AVDs — has Google Play services (FCM/Google Pay work) but no Play Store, so nothing auto-updates. Set internal storage ≥16 GB when creating. On Play-image AVDs, disable Play Store → Settings → Network preferences → Auto-update apps (resets on data wipe).

Evan's machine (as of 2026-07-16): only `google_apis_playstore` images installed; no cmdline-tools/sdkmanager CLI (Android Studio manages the SDK); AVDs: Pixel_10 (in use), Pixel_9a. Evan declined a headless cmdline-tools download — AVD changes go through Android Studio UI.

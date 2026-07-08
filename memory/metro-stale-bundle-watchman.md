---
name: metro-stale-bundle-watchman
description: Metro can serve a frozen bundle when watchman loses its watch roots — code edits and probes look inert on the simulator
metadata: 
  node_type: memory
  type: project
  originSessionId: 4547c55d-24ee-4403-b89f-4f3c52655839
---

In thrive worktrees, a long-running Metro (`pnpm dev`, port 10001 for patient) can silently serve a stale bundle: `watchman watch-list` shows `"roots": []` (watch deleted after Metro subscribed), so file changes never invalidate the graph — fast refresh and dev-client reloads both return old code with no error.

**Symptom:** edits (even loud ones like `barTintColor: '#555555'`) produce pixel-identical renders across reloads.
**Check:** fetch `http://localhost:10001/.expo/.virtual-metro-entry.bundle?platform=ios&dev=true&minify=false` and grep for a distinctive new string (comments are stripped — grep values, not comment tags); or `watchman watch-list`.
**Fix:** kill the Metro node process and restart with `pnpm dev` (includes `--clear`).

Also: `headerSearchBarOptions` values don't re-apply via fast refresh alone — remount the screen (navigate away and back) after changing them.

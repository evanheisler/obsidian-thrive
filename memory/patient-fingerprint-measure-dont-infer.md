---
name: patient-fingerprint-measure-dont-infer
description: Never infer OTA-safety from the Patient Fingerprint PR comment — its baseline falls back via restore-keys; generate the fingerprint and read its sources list
metadata: 
  node_type: memory
  type: project
  originSessionId: f81fc5bf-48a6-4b30-b4a1-27f125a75f47
  modified: 2026-07-29T21:26:12.927Z
---

`.github/workflows/patient-fingerprint.yaml` restores its baseline with
`restore-keys: patient-fingerprint-baseline-`, so when the PR's base SHA has no cached entry it
silently diffs against **some older `main`** and folds unrelated native churn into the comment.
On PR #961 that made the diff list webrtc, Stream SDK and `expo-screen-orientation` changes that
belonged to the base branch, not the PR.

**Measure instead.** From `apps/patient` in a worktree with `node_modules` installed:

```
npx -y @expo/fingerprint fingerprint:generate > fp.json
npx -y @expo/fingerprint fingerprint:diff <baseline.json> fp.json
```

`fp.json`'s `sources[]` is the authoritative input list (132 entries on `v2.3.0`, hash
`64f691c2…`). What it does and does not hash:

- **Hashed:** `eas.json`, `plugins/*.js` (`expoConfigPlugins`), `expoConfig`, the `android`/`ios`
  dirs, per-package `dir` entries for every autolinked package, and the derived
  `expoAutolinkingConfig:{android,ios}` / `rncoreAutolinkingConfig:{android,ios}` contents.
- **Not hashed:** `metro.config.js`, `eslint.config.mjs`, `pnpm-lock.yaml`, `pnpm-workspace.yaml`,
  app JS/TSX source. `apps/patient/package.json` enters only as
  `packageJson:scripts:lifecycle` — the dependency list itself is **not** hashed, so a dep change
  moves the fingerprint only when that package is autolinked.

Worked example (icon convergence, BH-3628): adding `@react-native-vector-icons/lucide` and
removing `expo-symbols` both move it (RN-core and Expo-iOS autolinked respectively); removing
`@expo/vector-icons` and `lucide-react-native` does not — neither appears in any source.

**How to apply:** grep the generated `sources[]` for the package or file in question before
claiming anything is OTA-safe. See [[feedback-no-fabricated-evidence]] — a plausible reading of
a CI comment is not proof, and being wrong here is only discovered after a release ships.

---
name: feedback-tests-must-cross-the-runtime-boundary
description: "Tests that stage their own inputs prove nothing about a vendor's validation — verify against the consuming tool's real surface, and read its loader before adding keys to files it owns"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-18T14:41:48.413Z
---

2026-08-18, PR #1079: BH-3895 shipped `"denylist": []` in `.design-sync/config.json`; the converter whitelist-validates that file and every `/design-sync` run died at `unknown key "denylist"`. Parity/assembly/internal/bot checks all passed — each staged its own config, so the converter's validation never executed. Evan: "Every error is yours because you do not do any actual research or testing. You just push code without consequence."

**Why:** All four design-workflow failures (black text, 20 unmountable components, checker-noise premise, denylist key) sat past the boundary the tests never crossed — the vendor's validator, RNW's renderer, the live design session. Green in-repo suites on staged inputs are indistinguishable from no testing for defects on the far side. The staged converter source was on disk the whole time; reading its config loader would have caught the key rejection at planning.

**How to apply:** Before a contract or diff adds a key, file, or convention to a surface another tool reads (config a converter validates, CSS a checker classifies, code a renderer executes), read that tool's loader/validator source first — it decides, not the repo's tests. When writing done-when clauses, ask which runtime boundary the artifact crosses and require verification on the far side of it; if only a live run can prove it, say so explicitly instead of letting staged-input tests stand in. Related: [[feedback-proposals-clear-the-binding-constraint]], [[feedback-machinery-priced-against-manual-baseline]].

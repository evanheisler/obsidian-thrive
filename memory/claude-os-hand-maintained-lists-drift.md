---
name: claude-os-hand-maintained-lists-drift
description: "claude-os is multi-machine — derive setup.sh lists from the config fragment, and a hook rename must sweep every reference including Codex"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1f7bfb7a-e2aa-43c7-916d-124f74e54193
  modified: 2026-08-19T15:42:49.727Z
---

`claude-os` installs to every machine Evan works on, so a name or list that drifts breaks all of
them on the next `setup.sh`. Two structural traps, found 2026-08-19:

**Hand-maintained lists silently stop working.** `setup.sh`'s hook merge pruned entries by a
hardcoded `OWNED` tuple of script names before re-adding from `global/settings-hooks.json`. The
fragment shipped 10 hooks; `OWNED` listed 8. The two it omitted were never pruned, so each
install appended another copy — `block-loop-publication.sh` reached 29 registrations,
`require-signed-commits.sh` 26. `OWNED` is now derived from the fragment by regex over each
hook's command, unioned with a `RETIRED` tuple for renamed/deleted scripts that still need
pruning on older machines. The **drift check** (`setup.sh` ~line 208) is still a hand-maintained
list of `registered()` calls and is currently missing `require-signed-commits.sh` — same bug
class, unfixed.

**A hook rename has four references, not one.** `hooks/<name>.sh`, `global/settings-hooks.json`,
the `setup.sh` drift check, and `global/codex/hooks.json` — the last is symlinked live into
`~/.codex/`, so missing it points Codex at a file `setup.sh` already deleted. `OWNED` needs
*both* names during a rename; the drift check needs *only* the new one.

**How to apply:** grep the whole repo for the old name before declaring a rename done, then
`setup.sh` followed by `setup.sh --check`, then run `setup.sh` a second time and confirm the
registration count is unchanged — idempotence is the only proof the pruning works. Never edit
under `~/.claude` directly; it holds copies. See [[feedback-shared-docs-stay-machine-agnostic]],
[[feedback-dont-repave-deliberate-wiring]], [[vault-retention-wiring]].

---
name: config-derives-from-repos
description: "All Claude config/skills/state derive from claude-os or obsidian-thrive — never create local machine overrides; doctor-style cleanups don't touch repos"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: eaef4f80-c8b0-481a-9185-f91e157e200b
  modified: 2026-07-31T17:35:42.880Z
---

Evan's setup derives all Claude config, skills, and state from the `~/claude-os` and `~/obsidian-thrive` repos so every machine is portable and reproducible. A "local cleanup" (e.g. /doctor) must not edit those repos, and must not create local overrides of repo-derived config (no `skillOverrides` masking claude-os-shipped skills, no local deletions of installed copies that setup.sh would resurrect).

**Why:** Local overrides fork machine state from the repos — the next `setup.sh` run either resurrects what was deleted or silently diverges, and the config stops being reproducible.

**How to apply:** Removals of repo-derived things (skills, rules files, CLAUDE.md content) are findings to hand to Evan for a claude-os/vault change, done as its own task in that repo. The only legitimate local-cleanup surface is machine state claude-os does not manage (e.g. plugin enablement in `~/.claude/settings.json`, MCP registrations in `~/.claude.json`). Related: [[claude-os-owns-nothing-work-related]], [[dont-repave-deliberate-wiring]].

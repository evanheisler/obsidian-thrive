---
name: feedback-shared-docs-stay-machine-agnostic
description: "Docs/skills in shared repos are for teammates — never write my machine's wiring (vault paths, zsh aliases, 1Password refs, token locations) into them"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: af78ee30-2966-4203-b497-b65686629141
---

Anything committed to a shared repo (thrive skills, READMEs, setup docs) must work for a
teammate with none of Evan's machine setup — no vault, no claude-os, no 1Password Agents
vault, no personal aliases, no service tokens. I rewrote the thrive Grafana skill's setup.md
around the vault config + `claude-grafana` alias + `op run` (2026-07-06); Evan: no one else
has any of that.

**Why:** Local wiring in shared docs is worse than missing docs — it sends teammates chasing
infrastructure that doesn't exist for them. The split mirrors
[[feedback-claude-os-owns-nothing-work-related]]: shared repo = team-generic mechanism and
facts; the vault's `os/config/` = how THIS machine wires it.

**How to apply:** Before committing doc changes to a shared repo, reread them as a teammate
on a fresh laptop: every path, alias, credential ref, and tool must be theirs to create or
already in the repo. Personal wiring goes in the vault (`os/config/mcp-servers.md` etc.) and
auto-memory, never the PR.

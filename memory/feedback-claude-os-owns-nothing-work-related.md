---
name: feedback-claude-os-owns-nothing-work-related
description: "claude-os owns ONLY the OS loop — never read, grep, or route MCP/work config through it; machine/context-specific config (e.g. Grafana MCP) lives in the thrive vault's .claude/"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: af78ee30-2966-4203-b497-b65686629141
---

The Grafana MCP config (and any machine- or Bionic-specific wiring) has nothing to do with
claude-os. It lives at `<vault>/.claude/mcp-grafana.json` (thrive vault). Two agents in a row
wrongly involved claude-os for it (2026-07-06); Evan called it a pervasive problem.

**Why:** claude-os is exclusively the OS loop (global behavior, hooks, session mechanics).
The claude-dir-guard hook's blanket message — "that tree is installed by the claude-os repo"
— is misleading for unmanaged files and is what keeps steering agents there. Coupling scope
decides the home ([[feedback-skill-placement-by-coupling]]): work-serving config → vault.

**How to apply:** When touching MCP config, tokens, or anything under `~/.claude` that serves
the work rather than the OS loop: do not grep or edit claude-os. Check
`<vault>/os/config/mcp-servers.md` for the recorded location and mechanism. If a guard-hook
message points at claude-os for such a file, the message is wrong for that file — the file
belongs in the vault's `.claude/`.

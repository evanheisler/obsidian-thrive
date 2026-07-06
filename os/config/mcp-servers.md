---
title: MCP Servers
summary: MCP registrations for this context — what, where configured, scope rationale
last_updated: 2026-07-06
---

# MCP servers

| Server | Transport | Purpose | Scope |
|---|---|---|---|
| grafana / grafana-dev | stdio — `docker run grafana/mcp-grafana` | Bionic observability, prod + dev (Loki, Azure Monitor, Alertmanager) | **opt-in only**: `claude --mcp-config ~/.claude/mcp-grafana.json` |
| posthog | HTTP | Product analytics — org Thrive, project Patient | user |
| postman | HTTP | API workspaces | user |
| context7 | HTTP + API key | Current library docs (docs-first rule) | user |
| expo-mcp | (project) | Expo tooling for the thrive app repo | `~/dev/thrive` |

**Grafana is deliberately NOT registered at user scope.** It is a stdio server that starts a
Docker container; user-scope registration would spin up containers on every session. The
standalone config file `~/.claude/mcp-grafana.json` is the mechanism: load it only in sessions
that need Grafana, via `claude --mcp-config ~/.claude/mcp-grafana.json`. Do not "fix" this by
registering it — the absence of a registration is the design (corrected after I paved over it,
`log: 2026-07-06`). Both servers verified working end-to-end (initialize + `list_datasources`
against prod and dev, tokens valid) `log: 2026-07-06`.

Tokens in `mcp-grafana.json` are plaintext; moving them to `op://Agents/Grafana/*` per the
credentials pattern is a pending manual step.

Adding a server: user scope for anything wanted in every session (register via `claude mcp`,
document here + machine-setup); repo `.mcp.json` only for repo-specific tooling and never with
a plaintext secret in a shared repo.

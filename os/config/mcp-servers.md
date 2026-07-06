---
title: MCP Servers
summary: MCP registrations for this context — what, where configured, scope rationale
last_updated: 2026-07-06
---

# MCP servers

| Server | Transport | Purpose | Scope |
|---|---|---|---|
| grafana / grafana-dev | stdio — `docker run grafana/mcp-grafana` | Bionic observability, prod + dev (Loki, Mimir, Tempo, Azure Monitor) | **opt-in only**: `claude-grafana` alias (~/.zshrc) |
| posthog | HTTP | Product analytics — org Thrive, project Patient ([[thrive-telemetry-phi]]) | user |
| postman | HTTP | API workspaces | user |
| context7 | HTTP + API key | Current library docs (docs-first rule) | user |
| expo-mcp | (project) | Expo tooling for the thrive app repo | `~/dev/thrive` |

**Grafana is deliberately NOT registered at user scope.** It is a stdio server that starts a
Docker container; user-scope registration would spin up containers on every session. The
standalone config file `<vault>/.claude/mcp-grafana.json` is the mechanism: load it only in
sessions that need Grafana, via the `claude-grafana` alias in `~/.zshrc`
(`claude --mcp-config "$HOME/obsidian-thrive/.claude/mcp-grafana.json"`). Do not
"fix" this by registering it — the absence of a registration is the design (corrected after I
paved over it, `log: 2026-07-06`).

**The config lives in this vault, not `~/.claude` and not claude-os.** It is Bionic-specific
machine wiring — coupling scope is this context (corrected 2026-07-06 after two agents in a row
reached for claude-os; claude-os is only the OS loop and has no MCP config).

**Instance migration 2026-07-06:** both servers point at the new instances
`https://grafana-new.bionichealth.com` (prod) and `https://grafana-new.dev.bionichealth.com`
(dev), Grafana 12.3.1, new service-account tokens. Verified end-to-end on both: `initialize` +
`list_datasources` (6 datasources: Azure Monitor, Loki `loki-new`, Loki Legacy, Mimir
`mimir` (default), Prometheus, Tempo) + Loki label queries. Old tokens were per-instance and
died with the migration. Notable changes from the old instances: the `app` Loki label is
replaced by `service_name`, there is no Alertmanager datasource, and pre-migration log history
lives only in Loki (Legacy). Headless verification recipe: pipe `initialize` +
`tools/call list_datasources` JSON-RPC into the configured server command over stdio.

**Tokens live in 1Password, never in the config.** `mcp-grafana.json` follows the credentials
pattern (claude-os `docs/machine-setup.md`): the server command is
`op run -- docker run -i --rm -e GRAFANA_URL -e GRAFANA_SERVICE_ACCOUNT_TOKEN grafana/mcp-grafana …`
with `op://Agents/Grafana/prod-token` / `op://Agents/Grafana/dev-token` set as env refs in the
config's `env` block; `op run` resolves them at spawn time. Rotating a token = update the
1Password item, restart the session — no config edit.

Adding a server: user scope for anything wanted in every session (register via `claude mcp`,
document here + machine-setup); repo `.mcp.json` only for repo-specific tooling and never with
a plaintext secret in a shared repo.

---
title: MCP Servers
summary: MCP registrations for this context — what, where configured, scope rationale
last_updated: 2026-07-24
---

# MCP servers

| Server | Transport | Purpose | Scope |
|---|---|---|---|
| grafana | stdio — `docker run grafana/mcp-grafana` | Bionic observability — one instance for all environments (Loki, Mimir, Tempo); env chosen by datasource | **opt-in only**: `claude-grafana` alias (~/.zshrc) |
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

**Unified-instance migration 2026-07-24:** dev and prod collapsed into ONE Grafana at
`https://grafana.ops.bionichealth.com`. The two prior servers (`grafana` →
`grafana-new.bionichealth.com`, `grafana-dev` → `grafana-new.dev.bionichealth.com`) are gone —
config is now a single `grafana` server; you pick the environment by choosing its Loki
datasource. Verified end-to-end: `initialize` + `list_datasources` (12 datasources) + Loki
label queries on `loki-dev-v2`. Key datasource facts:
- **Dev app logs = `loki-dev-v2`.** ⚠️ `loki-new` still exists but now means "Loki (infra-v2)"
  (cluster/infra logs, NOT app) — the UID meaning changed from the old instance.
- **Prod app logs not migrated yet** — only prod history (`loki-archive-legacy-prod`,
  `loki-archive-prod-v1`); a live prod Loki will appear when prod moves. The old prod instance
  `grafana-new.bionichealth.com` now 401s the old token (dead path — no fallback to keep).
- Metrics: `mimir-dev-v2` (dev), `mimir` = "infra-v2" default. Traces: `tempo-dev-v2` (dev),
  `tempo`. No Azure Monitor / standalone Prometheus / Alertmanager datasource.
- `service_name` still replaces the old `app` label; still no `stream` label.

Headless verification recipe: pipe `initialize` + `tools/call list_datasources` JSON-RPC into
the configured server command over stdio. The team-shared `grafana-log-debugging` skill
(thrive `.claude/skills/`) carries the same datasource facts — keep both in sync.

**Tokens live in 1Password, never in the config.** `mcp-grafana.json` follows the credentials
pattern (claude-os `docs/machine-setup.md`): the server command is
`op run -- docker run -i --rm -e GRAFANA_URL -e GRAFANA_SERVICE_ACCOUNT_TOKEN grafana/mcp-grafana …`
with `op://Agents/Grafana/ops-token` set as the env ref in the config's `env` block; `op run`
resolves it at spawn time. Rotating a token = update the 1Password item, restart the session —
no config edit. (The old `prod-token` / `dev-token` fields on the `Agents/Grafana` item are now
stale — they target the retired `grafana-new.*` instances; delete once those are decommissioned.)

Adding a server: user scope for anything wanted in every session (register via `claude mcp`,
document here + machine-setup); repo `.mcp.json` only for repo-specific tooling and never with
a plaintext secret in a shared repo.

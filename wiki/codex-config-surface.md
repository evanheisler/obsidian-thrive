---
title: Codex CLI Configuration Surface
summary: What Codex exposes for config projection — AGENTS.md precedence, Claude-compatible skills, full hook system, MCP, memories (researched 2026-08)
type: reference
last_updated: 2026-08-19
---

# Codex CLI configuration surface

Researched from official docs (learn.chatgpt.com, formerly developers.openai.com/codex) for the agent-os redesign `log: 2026-08-19`. Governs how shared agent-os config can be projected into Codex.

## Surfaces, by isomorphism with Claude Code

- **Skills — near-isomorphic.** Codex reads Claude's `SKILL.md` format (same `name`/`description` frontmatter, `scripts/`, `references/`, `assets/`); optional Codex extras in `agents/openai.yaml`. Discovery: `.agents/skills` (cwd → parents → repo root) → `~/.agents/skills` → `/etc/codex/skills` → bundled. Only the directory differs from `.claude/skills`. Per-skill disable via `[[skills.config]]` in `~/.codex/config.toml`. Custom prompts (`~/.codex/prompts/`) are deprecated in favor of skills. https://learn.chatgpt.com/docs/build-skills
- **Hooks — same shape, different mount.** Full lifecycle system: 11 events (SessionStart/End, Subagent Start/Stop, Pre/PostToolUse, PermissionRequest, UserPromptSubmit, Pre/PostCompact, Stop), same three-level JSON structure as Claude Code, same stdin payload keys, output supports `decision`/`additionalContext`/`systemMessage`. Locations: `~/.codex/hooks.json` or `[hooks]` in config.toml; project `.codex/` only if trusted. https://learn.chatgpt.com/docs/hooks
- **Instructions — AGENTS.md.** Global: `~/.codex/AGENTS.override.md` then `~/.codex/AGENTS.md` (first non-empty wins). Project: git root walking down to cwd, `AGENTS.override.md` → `AGENTS.md` → `project_doc_fallback_filenames` (this is the only way Codex reads `CLAUDE.md`). Files concatenate root-downward, 32 KiB default cap, rebuilt each run. https://learn.chatgpt.com/docs/agent-configuration/agents-md
- **MCP.** `[mcp_servers.<name>]` in `~/.codex/config.toml` (+ trusted-project config.toml); stdio and HTTP (OAuth default); `codex mcp add|list|login`. https://learn.chatgpt.com/docs/extend/mcp
- **Memories — machine-local, generated, opt-in.** `[features] memories = true`; auto-generated under `~/.codex/memories/`; not meant for hand-editing — no analog to a shared memory corpus. https://learn.chatgpt.com/docs/customization/memories
- **Config layering.** Base `~/.codex/config.toml` → trusted-project `.codex/config.toml` walked root→cwd → named profiles (`codex --profile <name>`).

## Projection implications

Skills and AGENTS.md are the two surfaces a shared repo serves almost for free; hooks port by re-registering the same scripts in Codex's format. The existing claude-os Codex bridge (see [[claude-os]]) predates full hook parity — only 1 of 9 hooks is registered for Codex, so the vault-commit guard, dir guard, signing guard, and publication guards do not run there. Full parity is now mechanically possible. Related: [[karpathy-llm-wiki]].

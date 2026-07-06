---
title: Skill Registry
summary: Every skill available in this context — trigger, scope, what it does
last_updated: 2026-07-06
---

# Skill Registry

Scope: **claude-os** = user-level, installed everywhere by `setup.sh`; **vault** = this repo's
`.claude/skills/`; **upstream** = skills-CLI-managed in `~/.agents/skills/`; **built-in** /
**plugin** = ships with Claude Code or the plugin marketplace.

**Placement rule — a skill's home is the scope of its *coupling*, not its task type — and
absence of config strings does not make a skill generic.** Bound to this context's tools, or
serving the work at all (Linear, Bionic repos, Evan's PR/review queues, `os/config/`) →
**vault**. claude-os is only the OS loop itself — behavior Evan wants identical in every
context (`log: 2026-07-06` — misclassified three review skills as generic; work-serving skills
and meta-skills are vault-scoped). Never vendor an upstream skill or edit
through its `~/.agents` symlink — the skills CLI clobbers edits and vendoring severs updates;
claude-os `setup.sh` owns divergences as a patch list (`MODEL_INVOCABLE`), upgrade path
`skills update && ./setup.sh`. Rule adopted from the personal vault, where both wrong paths were
tried first (`log: 2026-07-06`; personal vault `log: 2026-07-05`). When unsure, ask.

| Skill | Scope | Use when |
|---|---|---|
| `/session-close` | claude-os | Ending any session — log, distill, commit, push |
| `/capture` | claude-os | Ingesting external material into `sources/` + wiki |
| `/lint` | claude-os | Weekly vault + OS health check |
| `/vault-smoke-test` | this vault | First-startup pipeline check — delete after verified |

## Plan → build → ship loop (Linear)

| Skill | Scope | Use when |
|---|---|---|
| `/plan-project` | vault | Idea → PRD → ready-for-agent Linear queue (grill → PRD → tracer-bullet slices) |
| `/work-project` | vault | Drive a planned Linear project autonomously — parallel workers ship issues to draft PRs |
| `/ship-issue` | vault | One ready-for-agent Linear issue end-to-end in a worktree → draft PR, or park on blocker |
| `/orchestrating-linear-work` | vault | Large multi-domain Linear work — scope, decompose, hand off, resume |

## Work cadence & review

| Skill | Scope | Use when |
|---|---|---|
| `/weekly-review` | vault | All Hands weekly summary from Linear + merged PRs (bionic-health-app, thrive) |
| `/project-status-update` | vault | Linear "write a project update" nudge or overdue/at-risk update |
| `/monitor-code-review-requests` | vault | Work Evan's reviewer queue, one gated PR at a time |
| `/approval-gated-code-review` | vault | PR feedback on Evan's PRs — local fixes free, publication approval-gated |

Add context-specific skills (this vault's `.claude/skills/`) below as they're created.
New context-specific skills go through `superpowers:writing-skills` (TDD baseline before
deploy); the smoke-test canary is exempt as a pure pipeline check.

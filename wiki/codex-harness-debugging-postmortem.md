---
title: Codex Harness Debugging Post-Mortem — Worktrees and Network Sandboxing
summary: A Codex worktree-debugging session confused session-scoped sandbox policy with repository configuration, placed local shell behavior in shared OS configuration, and repeatedly stopped investigating after direct user questions. Read before diagnosing Codex shell, sandbox, network, or worktree failures.
last_updated: 2026-08-12
---

# Codex Harness Debugging Post-Mortem — Worktrees and Network Sandboxing

## Incident

`nwt` needed to create a Thrive worktree, install dependencies, and run the repository environment setup. The initial Codex session could not write Git refs and could not resolve `registry.npmjs.org`. The agent gave fragmented terminal-status answers instead of owning the debugging loop, incorrectly treated a direct request to diagnose the workflow as individual one-shot questions, and required repeated user commands to continue.

## Confirmed facts

- `nwt` is an interactive Zsh function in `~/.zshrc`; non-interactive Codex shells do not load it.
- Git worktree creation writes to the main repository's Git common directory. A session without write access to that directory cannot create the branch lock file.
- `workspace-write` network access is separate from filesystem write roots. Without `network_access = true`, `pnpm install` fails at DNS resolution even when the repository is writable.
- A running session keeps the sandbox map it was launched with. Editing `~/.codex/config.toml` only affects newly launched sessions.
- The first successful post-change run created `codex-test-3` and installed all 2,374 packages. Its environment setup did not run because the agent interrupted a long Storybook Playwright post-install hook.

## Failures

1. **Wrong ownership.** The agent first added an `nwt` executable and worktree-specific paths to `claude-os`. `nwt`, `~/.zshrc`, and `~/.local/bin` are local-machine shell concerns. Shared OS configuration must not own local directory layout or aliases.
2. **Wrong diagnosis.** The agent called the Git-ref failure a broad host restriction before verifying whether a new session had reloaded the local Codex configuration. It also proposed `danger-full-access`, which was materially broader than required.
3. **Missed configuration axis.** The minimal policy change was `sandbox_mode = "workspace-write"` with `[sandbox_workspace_write] network_access = true`; repository and Git metadata write access are a separate axis.
4. **Broken debugging loop.** Once the user requested debugging, the agent should have retained responsibility through a green end-to-end signal. Direct questions about the failure were diagnostic input, not a withdrawal of that authorization. It instead stopped and demanded repeated commands to continue.
5. **Premature completion.** A created worktree is not a runnable worktree. Do not report success until dependency install and the repo-declared setup hook complete; do not interrupt a live setup process merely to report partial evidence.

## Required operating behavior

- For Codex harness failures, establish and run one end-to-end loop: command discovery → `git worktree add` → dependency install → repository setup hook → required runtime prerequisite.
- Inspect the active session policy before attributing a failure to the host. Distinguish configuration persisted for future sessions from the sandbox granted to the current one.
- Keep the narrowest workable policy: `workspace-write`, the repository's Git common directory writable, and `network_access = true`. Do not recommend unrestricted sandboxing unless the task specifically requires it and the user accepts that risk.
- Keep local shell commands, aliases, cache locations, and worktree roots out of `claude-os` unless they are intentionally portable, machine-independent OS behavior.
- Continue an explicitly authorized debugging/fixing loop until the red-capable signal passes or a real external blocker remains. A user question during that loop does not reset authorization.

## Verification target

From a fresh Codex session, `zsh -ic 'nwt <branch>'` exits zero, the worktree exists under `~/worktrees/<repo>/<branch>`, its dependency install succeeds, and the repository setup hook has produced its required local environment files. Verify the app's declared runnable command from that worktree before calling the workflow complete.

---
name: feedback-no-compound-bash-commands
description: "never chain Bash calls with && ; | or redirects — compound commands escape the allow list and prompt Evan on every call, including read-only ones"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 61575ab0-8374-4109-b5a1-ab2607df5689
  modified: 2026-08-13T21:51:50.672Z
---

One command per Bash call. **No `&&`, no `;`, no `|`, no `$(...)`, no `2>&1`, no redirects** — in my own calls and in every subagent dispatch prompt.

**Why:** `~/.claude/settings.json` allow-lists `Bash(git *)`, `Bash(gh *)` etc. with `defaultMode: "auto"`, but a prefix rule only covers a whole line that is a single command. `cd <path> && git commit …` and `git log … | head -8` each contain an unlisted segment (`cd`, `head`), so the line falls through to the auto-mode classifier. Once it gates one call, the consecutive-block escalation prompts on *every* subsequent call from that agent — a read-only `git log` included. During the BH-3750 review handling this produced four permission prompts in a row with no context on what was being approved, on work Evan had already approved.

**How to apply:**
- `git -C /path/to/worktree <subcommand>` — never `cd … && git …`.
- Use the tool's own filtering: `git log -1 --format=…`, `gh api … --jq '…'`, `gh pr view --json …`. Never pipe to `head`/`grep`/`jq`.
- Anything not expressible as one command → use Read/Grep/Glob instead of a shell.
- Put this verbatim in every subagent prompt that will touch git or gh; the subagent's prompts land on Evan, not me.
- The `ship-issue` skill text says `cd "$WT" && cmd` — a dispatch prompt that copies that phrasing reproduces the failure (2026-08-13: three executors in one session told to "prefix every command with `cd <wt> && `"; the `git commit` prompt landed on Evan). Dispatch prompts must instruct `git -C <wt>` / absolute paths instead, explicitly.
- `Bash(pnpm *)` is in the allow list as of claude-os `1da335e` — pnpm prompts mean the compound-command failure, not a missing allow entry.

Related: [[feedback-instrument-dont-use-evan-as-sensor]], [[feedback-report-outcomes-not-plumbing]].

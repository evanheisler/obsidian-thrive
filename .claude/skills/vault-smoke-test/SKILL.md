---
name: vault-smoke-test
description: Use when verifying this vault's context-specific skill pipeline works (claude-os first-startup or post-setup check). Delete after verifying.
---

# Vault smoke test

Canary skill. Proves that skills in this vault's `.claude/skills/` are discovered and
invocable, and that the `os/skills.md` registry flow works. Not a real skill — delete it
(and its registry row) once verified.

## Steps

1. Confirm invocation: report that the skill loaded from `<vault>/.claude/skills/vault-smoke-test/`.
2. Report vault state: date of the last `log.md` entry and count of uncommitted changes
   (`git -C <vault> status --short | wc -l`).
3. Remind the user to delete this skill and its row in `os/skills.md` — the pipeline is verified.

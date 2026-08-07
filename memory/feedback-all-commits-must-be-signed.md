---
name: feedback-all-commits-must-be-signed
description: "Never disable commit signing — every commit Evan's account authors must be verified"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a46ad7fd-21cf-4b3c-b120-ac8b031daac0
  modified: 2026-08-07T16:56:37.725Z
---

Every commit must be signed. Never pass `-c commit.gpgsign=false`, `--no-gpg-sign`, or
otherwise override `commit.gpgsign=true` — not to dodge a prompt, not in a worktree, not in
a non-interactive context, not "just for a draft PR".

**Why:** commits go up under Evan's identity. An unverified commit is an unattributable one
on a repo where the verified badge is the signal that the account actually authored it.
Dropping the signature to avoid a possible prompt trades that guarantee for my convenience.

**How to apply:** commit with plain `git commit` and let the configured SSH signing key
(`gpg.format=ssh`, `user.signingkey=~/.ssh/id_ed25519.pub`) do its job. If signing fails,
that is a blocker to surface — never a thing to switch off. Verify with
`git log --format='%h %G?'` before pushing; anything other than `G` means stop and report.
Related: [[feedback-repo-edits-need-nwt-worktree]].

---
name: thrive-fingerprint-release-branch-false-positive
description: "Release-branch PRs in thrive inherit a bogus fingerprint:changed label — accepted, do not propose fixing it"
metadata: 
  node_type: memory
  type: project
  originSessionId: 468486d0-126b-4cb6-88da-14a9cd081218
  modified: 2026-08-05T16:16:05.126Z
---

`.github/workflows/patient-fingerprint.yaml` saves a baseline only on pushes to `main`
(line 10), and its restore falls back to a bare `patient-fingerprint-baseline-` prefix
(line 72). So a PR based on a release branch (`v2.3.0`) compares against a `main`
baseline and gets `fingerprint:changed` plus a "Native Runtime Change Detected"
comment listing the whole release-branch-vs-main drift as if it were the PR's own.

Evan's decision (2026-08-05): **accept it.** The only correct fix is computing the base
fingerprint in-job from `github.event.pull_request.base.sha`, which needs a second
`pnpm install` (base and head lockfiles differ, and the lockfile is part of what the
fingerprint measures). That roughly doubles a check that runs 2m57s today, on every
patient PR, to remove a cosmetic label on a minority of PRs. Cache-key scoping per
branch is cheaper but converts the false positive into a false negative on the first
PR of each new release branch.

When a stacked or release-branch PR shows `fingerprint:changed`, say it's inherited
from the base and move on. Do not re-propose the fix.

Related: [[thrive-node-modules-cache-no-payoff]], [[feedback-fix-must-pay-for-itself]]

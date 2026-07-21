---
name: thrive-node-modules-cache-no-payoff
description: "Caching node_modules in thrive CI does not pay off — measured, don't re-propose"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9e04ebff-d053-4fba-80a5-e9057402acb4
  modified: 2026-07-21T21:20:14.637Z
---

Caching `node_modules` (actions/cache, keyed on pnpm-lock.yaml, skip install on hit) to cut thrive's per-job `pnpm install` tax was built and measured on PR #891 (2026-07), then reverted. Cache-hit vs cache-miss `Setup` step: vitest 63s→60s (flat), patient-jest 86s→56s (−30s), **lint 63s→101s (+38s WORSE)**. Net break-even and inconsistent.

**Why:** the pnpm *store* is already cached (`actions/setup-node` `cache: pnpm`), so the ~55s is *linking* the tree, not downloading. Restoring a cached linked node_modules for a monorepo this size costs about as much as relinking (pnpm documents this). It also inflates Actions cache storage — itself a growing cost (storage doubled to 2,250 GiB-hrs by July).

The lever that DID measure out for the July cost spike (from #706's 1→11-job sharding) is **path-gating** the test suites by changed paths (skip whole suites on single-area PRs — 58% of July PRs, ~980 billed-min/mo). Don't re-propose node_modules caching for thrive without a materially different mechanism. Related: [[feedback-no-fabricated-evidence]], [[feedback-endstate-tracks-server-contract]].

---
title: Vault Index
summary: Navigation map for this context vault
last_updated: 2026-07-06
---

# Vault Index

Map over `wiki/` and `os/`. Updated whenever a page is added or a category changes.

## Wiki

### Thrive codebase

- [[thrive-repo-map]] — monorepo shape, packages matrix, doc locations, structural facts
- [[thrive-ehr-architecture]] — EHR app: Entra auth, Bionic/Medplum proxying, enforced patterns
- [[thrive-patient-architecture]] — patient app: auth migration, provider stack, intake, OTA, gotchas
- [[thrive-deployments]] — EHR ArgoCD/AKS pipeline; patient EAS builds + OTA channels + SWA web
- [[thrive-medplum-fhir]] — Medplum access paths, medplum-tanstack layer, document/presigned-URL rules
- [[thrive-telemetry-phi]] — PostHog-only telemetry, BAA/PHI policy, error-triage routing

### Process retrospectives

- [[work-project-orchestration-postmortem]] — DEXA/BH-3063 work-project failures by pattern (passivity, stale-state, reuse-enforcement, over-correction, noise, churn) + workflow guardrails. **Read before any /work-project run.**
- [[research-first-endstate-postmortem]] — read PR reviews shallowly, then recommended the low-churn option to dodge work before doing the research that proved a full sweep was right. **Read before making a recommendation off a code review.**
- [[published-text-discipline]] — what a loop may write into a PR or Linear comment: future work only as a link to an approved Linear issue, no tags, nothing unverified, no action items buried in prose. Why "decision"-shaped bans never caught it, and why the dispatch prompt binds where skill text doesn't. **Read before any /work-project or review-handling run.**
- [[design-iteration-postmortem-bh3680]] — a five-line declared map became three crashing generations of runtime derivation because every audit reviewed implementations, never the premise; complexity ratcheted, an agent's choice was laundered as "already decided," and green tests fabricated the invariant. **Read before iterating on any mechanism a subagent introduced, and before the second fix to the same mechanism.**

## OS

- [[skills]] — skill registry
- `os/workflows/` — deterministic procedures: [[session-close]]
- `os/config/` — context facts (repos, boards, MCPs, credentials pattern)
- [[claude-os]] — local install facts (repo path, drift check, memory symlink, vault-skill symlinks)
- [[mcp-servers]] — MCP registrations, scopes, grafana token status

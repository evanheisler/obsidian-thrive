---
title: Thrive Deployments
summary: How EHR (ArgoCD/AKS) and Patient (EAS builds + OTA + Azure SWA web) ship; environments and promotion
last_updated: 2026-07-06
---

# Thrive Deployments

Azure everywhere: ACR, AKS, Key Vault, Static Web Apps, Bicep. Two entirely different pipelines per app.

## EHR — GitOps to AKS

Merge to `main` → `.github/workflows/main.yaml`: tests (4-shard Vitest + 2-shard patient Jest) → **coverage ratchet** (bot raises thresholds, commits `[skip ci]`) → `full-deploy.yaml`: Docker build (`docker/ehr/Dockerfile`, 3-stage, Next standalone) → push to ACR tagged with the git SHA → org-level reusable workflows bump the kustomize overlay image tag **and** the ArgoCD app `targetRevision` (these are the `[skip ci] update dev deployment image` / `update dev argocd target revision` commits) → ArgoCD auto-syncs (prune + selfHeal).

- **Dev**: auto on merge. `ehr.dev.thrivebetter.com`, 1 replica, namespace `thrive-ehr`, ACR `acrb3gcdhh4eksjw`.
- **Prod**: cut a **GitHub Release** (`release.yaml`). `ehr.thrivebetter.com`, 3 replicas, ACR `acrcucoyulydsgok`.
- Ad-hoc dev deploy of a branch: label the PR `deploy` (`manual-deploy.yaml`).
- Runtime secrets: Azure Key Vault → External Secrets Operator (`kubernetes/ehr/base/external-secret.yaml`, 3m refresh). Build-time Next env from GHA var `EHR_NEXT_ENV_FILE`.
- Quirk: image listens on 3000 but k8s configmap sets `PORT=10000` (probes/service target 10000). `main` is protected; only the GitHub App pushes bot commits.

## Patient native — EAS builds + OTA

Dual-layer: EAS native builds (runtime = `@expo/fingerprint` hash) + expo-updates OTA for JS. Authoritative doc: `docs/deployments/patient-deployment-architecture.md`; ops: `docs/runbooks/patient-deployments.md`.

- **Channels**: `preview` → `staging` (env **production** — same env vars as prod, differs by channel/distribution) → `production`.
- **Builds**: manual `patient-build.yaml` (GHA is just a trigger; real work in `apps/patient/.eas/workflows/`). Mode `release` = all 6 build combos + store submits (TestFlight / Play internal); mode `refresh` = rebuild preview+staging only so EAS artifacts don't expire (~30 days) and the nightly OTA gate keeps matching.
- **OTA**: nightly cron (5am ET, `patient-ota-update.yaml`) publishes to preview + staging, with a `verify_updates_published` guardrail that fails on silent skips. **Production OTA is a manual republish of the verified staging update group** — no rebuild.
- **Fingerprint CI** (`patient-fingerprint.yaml`): PRs get labeled `fingerprint:compatible` or `fingerprint:changed`; a change means new native builds are required — runbook `docs/runbooks/patient-fingerprint-breaks.md`.
- eas-cli pinned `18.13.0` in triggers (18.13.1 bug).

## Patient web — Azure Static Web Apps

Per brand × env: `members[.dev].thrivebetter.com`, `members[.dev].getkyzatrex.com`. Builds run **on EAS VMs** (secret visibility), GHA only triggers (`deploy-patient-web.yaml` → `.eas/workflows/deploy-web.yaml`: expo export → sourcemaps to PostHog → strip maps → SWA deploy). Dev deploys auto on merge to main; prod is manual `patient-web-release.yaml`. Security headers + SPA fallback in `apps/patient/staticwebapp.config.json`.

## PR automation

Labels `claude-review` (runs `/review-pr` via claude-code-action, Opus) and `codex-review` (4 reviewer subagents) trigger AI reviews; Bicep what-if comments on `infra/**` changes; coverage table posted to every PR.

## Planned — releases as deploy artifacts

Target model (Linear project *Releases as deploy artifacts*, BH-3217–3220): a **GitHub Release per surface is that surface's prod-deploy artifact and its record**. Publishing a surface's Release IS the deploy; the tag prefix ties it to one surface; the Releases page becomes the deploy ledger (latest Release per surface = what's live, notes = what changed). Surfaces stay independent — no forced cross-surface commit parity; goal is per-deploy traceability, not sync.

- Tags: `ehr/prod/vX.Y.Z`, `app/vX.Y.0` (native build+submit), `ota/prod/...`, `ota/staging/...` (pre-release), `web/prod/vX.Y.Z` (all tenants) / `web/prod/<tenant>/vX.Y.Z`.
- EHR already works this way; the project generalizes it and retires the manual `workflow_dispatch` triggers. **Gate `release.yaml` to `ehr/prod/*` first** (BH-3217) or every new surface Release fires an EHR prod deploy.
- Web defaults to all tenants; per-tenant retained via tag. OTA is not a version (references the native version it targets); web mints no version.

## Related

[[thrive-repo-map]] · [[thrive-ehr-architecture]] · [[thrive-patient-architecture]]

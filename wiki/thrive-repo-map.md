---
title: Thrive Repo Map
summary: Monorepo shape, packages, doc locations, and structural facts for github.com/Bionic-Health/thrive
last_updated: 2026-07-06
---

# Thrive Repo Map

Local checkout: `~/dev/thrive`. pnpm workspaces + Turborepo. Two deployable apps + two storybooks; ten shared packages. Issues live in **Linear** (`BH-XXXX`) via the `linear` CLI — never `gh issue` (`docs/agents/issue-tracker.md`).

## Apps

- `apps/ehr` — clinician-facing EHR, Next.js 16 App Router. See [[thrive-ehr-architecture]].
- `apps/patient` — member app, Expo SDK 55, ships iOS/Android/Web from one codebase, multi-brand (thrive + kyzatrex via `EXPO_PUBLIC_BRAND`). See [[thrive-patient-architecture]].
- `apps/storybook-ehr`, `apps/storybook-patient` — component docs.

## Packages (all `@repo/*`)

| Package | Purpose | EHR | Patient |
|---|---|---|---|
| `hooks` | FHIR hooks, view models, medplum-tanstack layer, bionic-api context, intake network hooks | ✅ | ✅ |
| `tokens` | Brand palettes/themes (computed via culori), fonts, contrast utils | ✅ | ✅ |
| `config` | Env validation + `.env.local` auto-setup from Azure Key Vault | ✅ | ✅ |
| `utils` | Only export: `./posthog` — the PostHog policy module. See [[thrive-telemetry-phi]] | ✅ | ✅ |
| `access-control` | Feature gating: tenant → flags → patient attributes cascade; `Feature` enum, `Gate` | – | ✅ |
| `announcements` | Framework-agnostic one-time contextual messages | – | ✅ |
| `copy` | Brand-aware i18n (i18next); `CopyKey` type derived from `brands/default/en.json` | – | ✅ |
| `intake` | Pure intake wizard engine + `mwl` pathway; telemetry PII allowlist | – | ✅ |
| `eslint-config` | Flat config; **enforces container/form/presentational import boundaries** | dev | dev |
| `tsconfig` | Base TS configs. Patient does NOT use it (extends `expo/tsconfig.base`) | ✅ | – |

## Structural facts

- **No package builds.** Every package's `build` script is a no-op echo; apps consume raw TypeScript source through `exports` maps. Next/Metro transpile it.
- **pnpm catalog** in `pnpm-workspace.yaml` pins ~130 shared dep versions (`"catalog:"` refs). Never `pnpm update --recursive` — it expands catalog refs.
- **Tailwind skew:** EHR is Tailwind v4; patient is Tailwind v3 + NativeWind v4.
- Gotcha: `packages/tsconfig/base.json` declares stale `paths` (`@repo/tokens` → nonexistent `src/`); real resolution is workspace symlinks + exports maps.

## Where the repo documents itself

- Root `AGENTS.md`/`CLAUDE.md` + per-app `apps/*/AGENTS.md` (prescriptive conventions, worth rereading before app work).
- `docs/agents/` — `issue-tracker.md` (Linear CLI conventions incl. project `content` vs `description` trap), `triage-labels.md` (role→state/label map), `domain.md` (CONTEXT-MAP/ADR protocol).
- `docs/plans/` — ~20 dated design/plan docs (OTA fingerprint, theming, announcements, intake, video visits…). Check here before designing anything that sounds familiar.
- `docs/runbooks/` — patient-deployments, patient-fingerprint-breaks, error-triage.
- `docs/deployments/` — patient-deployment-architecture (authoritative OTA/build model), patient-web.
- `docs/medplum-documents.md` — document/presigned-URL patterns + anti-patterns. See [[thrive-medplum-fhir]].
- **Missing by design (so far):** no `CONTEXT-MAP.md`, no `docs/adr/`, no per-app `CONTEXT.md` — `docs/agents/domain.md` says proceed silently; they get created lazily by `/domain-modeling`.

## Repo-scoped Claude skills

`apps/patient/.claude/skills/`: `access-control`, `error-triage`, `multi-brand`, `patient-screenshot`, `patient-screenshot-mobile`. Project-level skills also cover FHIR (`fhir-search-and-batching`, `medplum-sdk-utilities`), analytics, review perspectives, `update-deps`, `write-pr`, `grafana-log-debugging`.

## Related

[[thrive-deployments]] · [[thrive-ehr-architecture]] · [[thrive-patient-architecture]] · [[thrive-medplum-fhir]] · [[thrive-telemetry-phi]]

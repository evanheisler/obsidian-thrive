---
title: Thrive EHR Architecture
summary: apps/ehr — Next.js 16 clinician EHR; auth, backend proxies, data layer, enforced patterns, gotchas
last_updated: 2026-07-06
---

# Thrive EHR Architecture

`apps/ehr` — Next.js 16 App Router, code under `src/`, React 19, `output: 'standalone'` → Docker/AKS (see [[thrive-deployments]]). Tailwind v4 + shadcn/ui (prefer shadcn, fetch via shadcn MCP — per `apps/ehr/AGENTS.md`).

## Feature map

Global nav: Dashboard, Patients, Tasks, Chat (`src/config/patient-navigation.ts`). The patient chart (`patients/[patientId]/`) is the bulk: problems/history, data (labs, observations, vitals, wearables, questionnaires), meds & prescribing (Rcopia), orders/tasks/referrals/faxing, plans & programs, documentation (documents/insights/notes), AI assistant. Also: schedule (Acuity), workflows, questionnaire builder, video-call (Stream), admin/observation-definitions, `/ui` gallery.

## Backend

- **Primary backend = Bionic API** (`BIONIC_API_BASE_URL`, helper `src/lib/api/config.ts`).
- **Medplum is proxied through the Bionic API** at `/medplum`. Client-side code hits the Next.js rewrite `/api/medplum` (CORS dodge, `next.config.ts`); server-side hits the Bionic URL directly. Client built in `src/components/providers.container.tsx`: `cacheTime: 0` (React Query owns caching), custom fetch injects bearer from a module-level `currentAccessToken` (so token refresh doesn't recreate the client), plus a `beforeunload` AbortController.
- Every external service sits behind an authenticated Next.js API proxy route (`src/app/api/`): LangGraph (streaming catch-all, needs `duplex: 'half'`), Stream chat/video token minting, Acuity, Vital labs, terminology (icd10cm/cpt/rxnorm/icd10pcs allow-list), fax, transcription, feature flags, workflows. `api/health` is the k8s probe.

## Auth

NextAuth v5 + **Microsoft Entra ID only** (`src/lib/auth.ts`; middleware via `src/proxy.ts`).

- `AUTH_REQUIRED_GROUP` gates by Azure AD group and **fails closed** — unset means nobody gets in.
- JWT strategy; proactive refresh 5 min before expiry (with an Azure double-`/v2.0` issuer strip).
- Azure identity → FHIR Practitioner mapping by telecom email search (`src/providers/current-practitioner.tsx`); blocking "Practitioner Not Found" screen if unmatched.
- Use `src/hooks/use-session.tsx`, not `next-auth/react` directly (lint-restricted).

## Enforced patterns

- **Container/form/presentational** split (`*.container.tsx` data boundary, `*.form.tsx` react-hook-form+zod, rest presentational) — enforced by `@repo/eslint-config` import-boundary rules.
- **`@repo/hooks` barrels are banned outside client boundaries** (`eslint.config.mjs:100-136`) — they transitively pull client-only APIs and break Server Component bundling. Non-boundary files must use data-only subpaths.
- Data layer: TanStack Query over Medplum via `packages/hooks/src/medplum-tanstack/` (see [[thrive-medplum-fhir]]). Query defaults: staleTime 5m, gcTime 10m, retry 1, no refetch-on-focus.
- URL sync for already-rendered UI state uses raw `history.pushState` (not the router) to avoid re-renders — the "Document Viewer Pattern" in `apps/ehr/AGENTS.md`.
- AI assistant: `src/providers/langgraph/` wraps `@langchain/langgraph-sdk/react` `useStream` incl. interrupts/tool-call confirmations.

## Gotchas

- Env contract validated at startup via `src/instrumentation.ts` → `config/environment.ts` — fails fast on missing vars.
- PostHog `console.error` capture is the deliberate error pipeline; bodies truncated to 500 chars ("acceptable under BAA"). See [[thrive-telemetry-phi]].
- `transpilePackages: ['@repo/tokens']`; `prepare-fonts.sh` before vercel-build; `postbuild` uploads PostHog sourcemaps.
- Tests: Vitest + happy-dom, iframe loading disabled in `src/test/setup.ts` (CI OOM), MSW + `@medplum/mock`, ~229 test files, 4-shard CI with a post-merge coverage ratchet.

## Load-bearing files

`src/components/providers.container.tsx` · `src/lib/auth.ts` + `src/proxy.ts` · `src/lib/api/config.ts` + `next.config.ts` · `src/config/patient-navigation.ts` · `packages/hooks/src/medplum-tanstack/README.md` · `eslint.config.mjs` · `config/environment.ts`

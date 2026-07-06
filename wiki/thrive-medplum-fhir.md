---
title: Thrive Medplum/FHIR Integration
summary: How both apps reach Medplum, the medplum-tanstack data layer, view models, and document/presigned-URL rules
last_updated: 2026-07-06
---

# Thrive Medplum/FHIR Integration

Medplum is never hit directly by browsers — both apps reach it **through the Bionic API** at `/medplum` (EHR additionally via a Next.js `/api/medplum` rewrite client-side to dodge CORS). Both clients set `cacheTime: 0` and delegate all caching to TanStack Query, and both use a custom `fetch` that injects the app's own auth bearer (Entra ID token in EHR, Rownd/SuperTokens token in patient) — there is no Medplum-native auth.

## Data layer

- `packages/hooks/src/medplum-tanstack/` — TanStack Query wrapper over Medplum: `useResource`, `useSearch`, `useSearchOne`, `useSearchResources`, mutation hooks, `useExecuteBatch`, `medplumQueryKeys` (`['medplum', resourceType, searchFn, query]`), `medplumCacheUtilities`. Its README is the reference doc.
- `@repo/hooks/models` — ~24 FHIR→view-model transforms; every VM keeps the raw resource on `_original`.
- Domain hooks: ~35 `use-*` in `packages/hooks/src/fhir/` (shared) plus app-local hooks.
- Patient app: FHIR Patient found by identifier `ROWND_USER_ID_SYSTEM|<userId>`, one search with `_revinclude` CareTeam/Group + `_include:iterate` Practitioner.
- EHR: clinician identity mapped Azure → Practitioner by telecom email.

Skills that apply when writing FHIR code: `fhir-search-and-batching` (query consolidation) and `medplum-sdk-utilities` (CodeableConcept/extension/identifier helpers). Use them rather than hand-rolling.

## Documents (from `docs/medplum-documents.md` — read it before touching documents)

Medplum stores files in Azure Blob; attachment URLs are **presigned** — time-limited, pre-authenticated, fetched directly by the browser.

- Notes/HTML → base64 in `attachment.data`, decode inline.
- PDF/image/video → pass presigned `attachment.url` straight to iframe/img/video.
- Text/VTT/XML/JSON → presigned URLs block browser `fetch()` (CORS); use `extractBinaryId()` from `@repo/hooks/fhir` + `medplum.download('Binary/{id}')`.
- Iframes: HTML `srcDoc` gets `sandbox=""`; PDF data-URL iframes get **no** sandbox (any level kills the built-in PDF viewer).
- **Anti-patterns (documented, do not build):** document content proxy routes, custom Binary download logic, auth-token injection for blob URLs.

## Related

[[thrive-ehr-architecture]] · [[thrive-patient-architecture]] · [[thrive-repo-map]]

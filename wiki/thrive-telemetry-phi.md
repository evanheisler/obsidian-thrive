---
title: Thrive Telemetry & PHI Policy
summary: PostHog is the only telemetry/error pipeline (BAA in place); policy lives in @repo/utils/posthog; where errors go per surface
last_updated: 2026-07-06
---

# Thrive Telemetry & PHI Policy

**PostHog is the telemetry AND error-tracking stack for all three surfaces (EHR, patient web, patient native). There is no Sentry.** This is a healthcare app under a BAA with PostHog — the comment "PHI risk accepted — BAA in place" lives in code, and PHI-safety decisions are deliberate, not accidental. Consult the `analytics` skill before touching instrumentation.

## Single source of truth: `packages/utils/src/posthog/`

`posthogConfig` exposes per-surface init options (`ehr`, `patientWeb`, `patientNative`). Its `before_send` pipeline is load-bearing policy:

- Scrubs auth magic-link params (`preAuthSessionId`, `linkCode` — SuperTokens) from `$current_url`/`$referrer`.
- Fingerprints MedplumProvider exceptions by HTTP method+path so distinct endpoints don't merge into one error group.
- Drops known noise: iOS keychain "User interaction is not allowed", Rownd hub "Missing app id" race.
- `isInternalUser` flags bionichealth.com / thrivebetter.com / mdoholdings.com as `is_employee`; internal-user *filtering* is intentionally disabled for now (still validating setup).
- Written DOM-free on purpose (shared with native) — string ops, not the URL API.

## Per surface

- **EHR**: `console.error` capture is the deliberate error pipeline; error bodies truncated to 500 chars. Degrades gracefully when `NEXT_PUBLIC_POSTHOG_KEY` is absent. Sourcemaps uploaded in `postbuild`.
- **Patient native**: autocaptures uncaught exceptions, unhandled rejections, console errors (toggles in `app.config.ts` `extra`, all default on). Session replay is **opt-in per device** and off on web. `ReleaseTracker` super-props include `brand`, `app_update_channel`, `bundle_id` (OTA update id) — essential for correlating errors to OTA releases. Sourcemaps via posthog-cli (web script + gradle/Xcode plugins).
- **Patient PostHog project**: "Patient", id 348039 (the MCP default).

## Where to look when things break

- Patient app errors → PostHog, triaged via the `error-triage` skill + `docs/runbooks/error-triage.md`.
- Backend/EHR-server-side (bionic-health API, medplum, workers, k8s services) → Grafana Loki, via the `grafana-log-debugging` skill. The patient app does NOT log there.

## Related

[[thrive-patient-architecture]] · [[thrive-ehr-architecture]] · [[thrive-repo-map]]

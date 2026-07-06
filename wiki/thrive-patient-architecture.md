---
title: Thrive Patient App Architecture
summary: apps/patient — Expo SDK 55 member app; auth migration, provider stack, intake, OTA, gotchas
last_updated: 2026-07-06
---

# Thrive Patient App Architecture

`apps/patient` — Expo SDK 55 / RN 0.83 / React 19, expo-router (typed routes), ships iOS + Android + Web (Metro web, `output: 'single'`). Bundle `com.bionichealth.members`, EAS project `member-app`. **Multi-brand**: thrive + kyzatrex from one binary via `EXPO_PUBLIC_BRAND` (`app.config.ts` `brandEnvironment()`/`brandAsset()`). Currently **dark-mode-only** — `colorScheme` hardcoded in `theme/brand-theme-colors.ts` (BH-2370).

## Feature map

Tabs (`app/(tabs)/`): Home (dashboard, biomarkers, health actions), My Health (pillars, biomarkers), Care Team (+ insights), Search, More (account, schedule, wearables, documents, appointments). Plus: chat (`care-team` = Stream Chat, `ai-assistant` = LangGraph, gated by `Feature.AiAssistant`), full-screen Stream Video visits (`app/video-call.tsx`), onboarding interest picker → self-serve **intake** (`app/intake/[pathway]/[step].tsx` driven by `@repo/intake`; kyzatrex forces testosterone pathway).

## Backend

- Base: `https://api[.dev].bionichealth.com`. Medplum at `${base}/api/v1/medplum` (`providers/medplum-provider.tsx`): `cacheTime: 0`, custom fetch injects bearer with a 10s timeout race, strips `x-medplum`/`content-length`/`host` headers, `cache: 'no-store'`. Native requires `@medplum/expo-polyfills` — `polyfills.ts` must stay the **first import** in `app/_layout.tsx`.
- Custom Bionic REST client: `utils/bionic-client.ts` + `lib/bionic-api-fetcher.ts` (patient-scoped paths). Feature flags from `/api/v1/features/`.
- SDKs: Stream Chat + Video, Stripe (hosted checkout; kyzatrex is a Stripe Connect connected account resolved per-request by the backend), Vital (wearables), LangGraph, Turnstile.

## Auth (mid-migration)

Pluggable behind `providers/auth/auth-context.ts` + `useAuth()`. **Rownd is the default** (passwordless magic links); **SuperTokens** is the target, toggled by `EXPO_PUBLIC_USE_SUPERTOKENS` — consumers were rewired `useRownd()` → `useAuth()` in BH-3103 (PR #739). RowndProvider still mounts even in SuperTokens mode. Entry gating in `app/index.tsx`: unauthenticated → login; no FHIR Patient (`provisioningStatus === 'unprovisioned'`) → onboarding/intake; else tabs. Patient looked up by identifier `ROWND_USER_ID_SYSTEM|userId`. JWT-audience mismatch after cross-env OTA triggers auto-signOut. Biometric app lock (`contexts/app-lock-context.tsx`) silently bypasses without hardware — known HIPAA gap BH-2700.

## State, styling, copy

- TanStack Query is the cache; everything else React Context. `components/providers.container.tsx` is a deep, **order-sensitive** provider stack (holds render until startup prefs load; single shared PortalHost — nesting another breaks bottom sheets).
- NativeWind v4 + Tailwind v3; semantic tokens are CSS vars injected at runtime from `@repo/tokens`. Two theming worlds: className (live CSS vars) vs resolved color strings passed to SDKs (Stream, NativeTabs) — the latter don't re-theme live.
- Copy via `@repo/copy`; lint forbids literal JSX strings; **never call `getCopy()` at module scope in route files** (routes resolve before CopyProvider mounts → crash).
- Gating via `@repo/access-control` (`Feature`, `Gate`, `RouteGate`) — repo skill `access-control` covers it.

## OTA / builds

`runtimeVersion.policy: 'fingerprint'`. Update flow in `hooks/use-app-updates.ts` (foreground checks, auto-reload when pending, `safeReloadAsync` with GC delay to dodge a Hermes SIGSEGV). Channels/promotion in [[thrive-deployments]]. Never edit `ios/`/`android/` — prebuild-generated; native config only via `app.config.ts` + plugins (`plugins/`).

## Gotchas

- NativeTabs is `expo-router/unstable-native-tabs` (beta): single icon per trigger (variant races crash RNScreens), Android tab drawable hardcoded to Thrive (`with-thrive-tab-drawable.js` — not brand-aware), tab color scheme needs a `react-native-screens` patch (patch-package).
- `metro.config.js` monkey-patches `process.stdout.write` to silence stream-chat CSS warnings.
- Screenshots blocked by default (FLAG_SECURE); `EXPO_PUBLIC_ALLOW_SCREENSHOTS` for dev/QA — matters for the screenshot skills.
- Android blocks `READ_MEDIA_IMAGES/VIDEO` perms that a plugin pulls in unused (Google Play rejection).
- Cross-platform parity is a stated requirement; use `.ios/.android/.web` extensions.

## Load-bearing files

`app.config.ts` · `eas.json` · `components/providers.container.tsx` · `providers/auth/*` · `providers/medplum-provider.tsx` + `providers/patient-profile-provider.tsx` · `hooks/use-app-updates.ts` · `apps/patient/AGENTS.md`

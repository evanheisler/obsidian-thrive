---
title: Thrive Patient App Architecture
summary: apps/patient — Expo SDK 55 member app; auth migration, provider stack, intake, OTA, gotchas
last_updated: 2026-07-16
---

# Thrive Patient App Architecture

`apps/patient` — Expo SDK 55 / RN 0.83 / React 19, expo-router (typed routes), ships iOS + Android + Web (Metro web, `output: 'single'`). Bundle `com.bionichealth.members`, EAS project `member-app`. **Multi-brand**: thrive + kyzatrex from one binary via `EXPO_PUBLIC_BRAND` (`app.config.ts` `brandEnvironment()`/`brandAsset()`). Currently **dark-mode-only** — `colorScheme` hardcoded in `theme/brand-theme-colors.ts` (BH-2370).

## Feature map

Tabs (`app/(tabs)/`): Home (dashboard, biomarkers, health actions), My Health (pillars, biomarkers), Care Team (+ insights), Search, More (account, schedule, wearables, documents, appointments). Plus: chat (`care-team` = Stream Chat, `ai-assistant` = LangGraph, gated by `Feature.AiAssistant`), full-screen Stream Video visits (`app/video-call.tsx`), onboarding interest picker → self-serve **intake** (`app/intake/[pathway]/[step].tsx` driven by `@repo/intake`; kyzatrex forces testosterone pathway).

## Backend

- Base: `https://api[.dev].bionichealth.com`. Medplum at `${base}/api/v1/medplum` (`providers/medplum-provider.tsx`): `cacheTime: 0`, custom fetch injects bearer with a 10s timeout race, strips `x-medplum`/`content-length`/`host` headers, `cache: 'no-store'`. Native requires `@medplum/expo-polyfills` — `polyfills.ts` must stay the **first import** in `app/_layout.tsx`.
- Custom Bionic REST client: `utils/bionic-client.ts` behind the `bionic-api` provider in `@repo/hooks` (PR #875, 2026-07-21). One `BionicApiProvider` wires two transports — authed `fetcher` + tokenless `publicFetcher` (fail-closed: `useBionicPublicApi` never falls back to the authed one) — exposed as `useBionicApi(base?)` / `useBionicPublicApi(base?)`. **Paths are literal** — the fetcher never inspects or rewrites them (killed the old `startsWith('/api/')` sniff + magic `/api/v1/patients/{id}` prefix). Feature flags from `/api/v1/features/`.
- **Direction — patient scoping is moving server-side (FHIR-style), 2026-07-21.** Per the refactor author (jellis18), the backend is relocating patient access from path-based (`/api/v1/patients/{id}/…`) to FHIR-style: the auth token identifies the patient and the **server** enforces the scope. The `/patients/{id}/` path segment is therefore **transitional** — hooks that still thread `patientId` (scheduling, `use-biomarker-scores`, `use-wearable-providers`, `use-stripe-customer-portal`) are shims on the way out, not a pattern to build on. Do **not** design new client abstractions around patient-id-in-path (a scope hook, provider-injected `currentPatientId`, etc.) — that responsibility is leaving the client. Patient identity may still be wanted in react-query keys for per-login cache identity, but sourced from auth/profile, not as a path input. See [[thrive-medplum-fhir]].
- SDKs: Stream Chat + Video, Stripe (hosted checkout; kyzatrex is a Stripe Connect connected account resolved per-request by the backend), Vital (wearables), LangGraph, Turnstile.

## Auth (mid-migration)

Pluggable behind `providers/auth/auth-context.ts` + `useAuth()`. **Rownd is the default** (passwordless magic links); **SuperTokens** is the target, toggled by `EXPO_PUBLIC_USE_SUPERTOKENS` — consumers were rewired `useRownd()` → `useAuth()` in BH-3103 (PR #739). RowndProvider still mounts even in SuperTokens mode. Entry gating in `app/index.tsx`: unauthenticated → login; no FHIR Patient (`provisioningStatus === 'unprovisioned'`) → onboarding/intake; else tabs. Patient looked up by identifier `ROWND_USER_ID_SYSTEM|userId`. JWT-audience mismatch after cross-env OTA triggers auto-signOut. Biometric app lock (`contexts/app-lock-context.tsx`) silently bypasses without hardware — known HIPAA gap BH-2700.

## State, styling, copy

- TanStack Query is the cache; everything else React Context. `components/providers.container.tsx` is a deep, **order-sensitive** provider stack (holds render until startup prefs load; single shared PortalHost — nesting another breaks bottom sheets).
- NativeWind v4 + Tailwind v3; semantic tokens are CSS vars injected at runtime from `@repo/tokens`. Two theming worlds: className (live CSS vars) vs resolved values passed to SDKs (Stream, NativeTabs) — the latter don't re-theme live.
- **The `theme/brand-*.ts` bridges are axis-parallel — one per token axis, same shape** (`log: 2026-07-16`). Each resolves tokens to plain values for style-object sinks that expose no `className`: Victory labels, markdown style maps, Stripe appearance, nav options. `brand-theme-colors.ts` (color) → `brand-font-names.ts` (family, docstring: "Mirrors brand-theme-colors.ts — same pattern, different token type") → `brand-type-styles.ts` (`typeStyle(slot): TextStyle`, added by BH-3318). **Before concluding a sink "can't" take a token, look for its axis's sibling** — the data is already there (`BRAND_TYPE` exposes size/lineHeight/letterSpacing/uppercase as plain values; `typography.stories.tsx` reads them). Assuming that bridge didn't exist is what stalled BH-3272 into a cancel. See [[feedback-no-unverified-capability-gaps]].
- Typography: `<Text variant>` (`components/ui/text.tsx`) baskets the 14 Figma slots; it owns **no color** — call sites name it. `<Heading level={1..4}>` (`components/ui/heading.tsx`) is semantics-only, delegating all type to `<Text variant>`: `h1`–`h4` are legitimate slots for non-heading text, so the scale can't imply `accessibilityRole="header"`. It `Omit`s `variant`/`aria-level`/`accessibilityRole` and spreads `rest` first, so a call site can't drop or override the contract (`log: 2026-07-16`).
- Copy via `@repo/copy`; lint forbids literal JSX strings; **never call `getCopy()` at module scope in route files** (routes resolve before CopyProvider mounts → crash).
- Gating via `@repo/access-control` (`Feature`, `Gate`, `RouteGate`) — repo skill `access-control` covers it.

## OTA / builds

`runtimeVersion.policy: 'fingerprint'`. Update flow in `hooks/use-app-updates.ts` (foreground checks, auto-reload when pending, `safeReloadAsync` with GC delay to dodge a Hermes SIGSEGV). Channels/promotion in [[thrive-deployments]]. Never edit `ios/`/`android/` — prebuild-generated; native config only via `app.config.ts` + plugins (`plugins/`).

## Feature gating (home revamp model, `log: 2026-07-13`)

Two gates with distinct jobs — never conflate:
- **Development**: `@repo/access-control` alone. Feature registered with `rule: () => 'hidden'` (no flag) so it's hidden everywhere; devs opt in per-session via the development-overrides context (`setAccessOverride(feature, 'full')`, a Switch row in More-tab dev tools, non-prod only, no persistence). `ModernHeader` and `HomeRevamp` both follow this.
- **Release**: feature-toggle-service, later — wire a flag into the registry rule (prod early access = FTS allowlist; prod default = enable env in FTS; dev default = drop the hidden rule).
Consumers go through per-surface wrapper hooks (`useHomeRevampHome`/`useHomeRevampTasks` = `useAccess(...).level === 'full'`), never `useAccess` directly, so a flag split stays a one-line change. Component-organization convention (route → container → components, no single-use abstractions, domain = concern) lives in the repo: `apps/patient/.claude/skills/component-organization/SKILL.md` + `apps/patient/AGENTS.md`.

## Gotchas

- NativeTabs is `expo-router/unstable-native-tabs` (beta): single icon per trigger (variant races crash RNScreens), Android tab drawable hardcoded to Thrive (`with-thrive-tab-drawable.js` — not brand-aware), tab color scheme needs a `react-native-screens` patch (patch-package).
- `metro.config.js` monkey-patches `process.stdout.write` to silence stream-chat CSS warnings.
- Screenshots blocked by default (FLAG_SECURE); `EXPO_PUBLIC_ALLOW_SCREENSHOTS` for dev/QA — matters for the screenshot skills.
- Android blocks `READ_MEDIA_IMAGES/VIDEO` perms that a plugin pulls in unused (Google Play rejection).
- Cross-platform parity is a stated requirement; use `.ios/.android/.web` extensions.

- `theme/brand-theme-colors.ts` `brandThemeColors` is resolved ONCE at module load, pinned dark — passing it into rendered UI (e.g. tinting icons) diverges from the live CSS-var path Tailwind classes use. It exists for third-party SDK APIs only; in components, color label and icon through one token path (Button bug, `log: 2026-07-13`).
- Executors/agents must never start Metro/Expo servers — every checkout defaults to ports 10000/10001 and collides with Evan's running session (`log: 2026-07-13`).
- **react-native-css-interop resolves px-suffixed CSS vars with `parseInt`**, so fractional values floor to 0 on native (web unaffected). This is why `typeVariables()` in `@repo/tokens/type` deliberately emits **no** tracking var — Thrive's sub-px letter-spacing would silently become 0. Style-object consumers (`typeStyle()`) take a real number and keep it, so the bridge path is *more* faithful than className here (`log: 2026-07-16`).
- **`theme/retired-tokens.guard.test.ts` scans built artifacts.** Build storybook locally (`pnpm --filter storybook-patient build`) and `pnpm test` then fails with a bogus offender like `storybook-static/assets/iframe-*.js: border-muted`. Not a regression — delete `apps/storybook-patient/storybook-static` (`git clean -xfd <path>`) and re-run (`log: 2026-07-16`).

## Load-bearing files

`app.config.ts` · `eas.json` · `components/providers.container.tsx` · `providers/auth/*` · `providers/medplum-provider.tsx` + `providers/patient-profile-provider.tsx` · `hooks/use-app-updates.ts` · `apps/patient/AGENTS.md`

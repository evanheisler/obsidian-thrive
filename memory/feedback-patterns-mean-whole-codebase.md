---
name: ""
metadata: 
  node_type: memory
  originSessionId: 5897effd-5458-406e-9128-044aaaf3d91d
---

When Evan asks "what can you tell from this codebase's patterns?" (or any
pattern/convention question), **search the entire repo for the pattern** — grep
across `apps/` and `packages/` for the utility, the call sites, the config.
Never infer the convention from the one feature path already in front of you.

**Why:** Reviewing add-to-calendar, I read only `components/scheduling` (a
product *funnel*: `scheduler_sheet_opened`/`appointment_scheduled`) and
concluded "this codebase uses PostHog for funnels, not errors — a swallowed
`catch {}` is house style." That was categorically wrong. A repo-wide grep
(`captureException|capture.*error|reportError`) immediately surfaced a house
`captureError`/`captureCustomError` util (`@/utils/error-tracking`) used in
video-context, intake-telemetry, etc., plus `capture_unhandled_errors` /
`capture_console_errors` auto-capture. **Errors are reported to PostHog almost
everywhere**; the empty catch was a real bug, not a convention.

**How to apply:**
- Pattern question → `grep -rn <pattern> apps packages` FIRST; the feature path
  is a sample, not the population.
- A swallowed `catch` in this repo is a defect: report via
  `captureError(posthog, error, { feature, context })` (from
  `@/utils/error-tracking`, `usePostHog()` from `@/contexts/posthog-context`).
  See [[thrive-telemetry-phi]].
- Don't label an anti-pattern "house style" without verifying against the
  actual shared utility. Relates to [[feedback-locate-the-referent-first]] and
  [[feedback-resolve-framing-dont-confirm-it]].

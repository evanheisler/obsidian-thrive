---
name: home-revamp-toggle-user-opt-in
description: "Home revamp toggle model (corrected 2026-07-13) — access-control gates development, FTS gates release; dev opt-in = existing dev-overrides framework, never bespoke"
metadata:
  node_type: memory
  type: project
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
---

Patient-app home revamp toggle model, corrected by Evan at PR #820 review (2026-07-13) after my issue spec (BH-3251) got it wrong:

- **Legacy home renders by default in ALL environments.** `Feature.HomeRevamp` mirrors `Feature.ModernHeader`: registry rule `() => 'hidden'`, no flag wired day 1.
- **Development opt-in = the existing development-overrides framework** (`setAccessOverride(Feature.HomeRevamp, 'full')`, a Switch row in the More-tab dev-tools section, non-prod only, no persistence — framework behavior is the spec). Never bespoke storage, never a prod-functional client opt-in.
- **FTS's ONLY job is server-side release gating, later:** prod early access = wire `home_revamp` flag into the registry rule + FTS allowlist; prod default = enable env in FTS; dev default = remove the access-control hidden rule. FTS is NOT a prerequisite for testing during development.
- Wrapper hooks (`useHomeRevampHome`/`useHomeRevampTasks`) stay as the only consumption path, but are just `useAccess(...).level === 'full'` — no isReady/blank-screen guard; loading resolves `hidden` → legacy.

**My original error (do not repeat):** I turned "user groups in prod can early access" into a persisted client-side opt-in shipping in prod and declared the dev-overrides context "unsuitable" — specing bespoke plumbing (`use-home-revamp-opt-in.ts`, Gate-wrapped prod card) that repaved an existing framework. Prod early access belongs to FTS. Related: [[feedback-dont-repave-deliberate-wiring]], [[feedback-no-single-use-abstractions]].

See [[thrive-patient-architecture]].

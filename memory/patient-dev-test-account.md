---
name: patient-dev-test-account
description: The only patient-app dev member is evan.heisler+202602@bionichealth.com; the harness userEmail is a staff identity and never authenticates the app
metadata: 
  node_type: memory
  type: reference
  originSessionId: 513b2f4a-de9a-46ee-a724-c4d747384ab5
---

Driving the patient app against dev requires a **real member account**. The only one is:

```
evan.heisler+202602@bionichealth.com
```

Use it with `apps/patient/scripts/magic-link.sh <email> <port>`.

**Never use `evan.heisler@bionichealth.com`.** The harness injects it as `userEmail` in the
system prompt, but it is Evan's **staff identity** (Entra / GitHub / Linear) — he is an
employee, not a member. It has no member record in dev and *will never work*. The script's
built-in default `dev@bionichealth.com` is not a real user either.

**Why:** the failure is silent and misleading. A non-existent member still mints a valid magic
link (exit 0), the redirect lands on the app, and the app throws
`OperationOutcomeError: Unauthorized` with **zero requests to `api.dev.bionichealth.com`** —
it reads like a broken auth path or missing env, not like "no such user." That symptom burned
a long debugging detour into env vars, Rownd/SuperTokens flags, and network captures. See
[[feedback-never-invent-an-account]].

**How to apply:** an account is a fact you are given, never one you derive. Before driving the
app, use the address above; if a different persona is needed, ask. `userEmail` in the system
prompt identifies who you are *talking to*, not an account in any product they work on.

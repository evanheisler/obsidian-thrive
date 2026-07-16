---
name: feedback-never-invent-an-account
description: "Never guess a login/account/persona — ask; a missing account is a fact to request, not a bug to debug"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 513b2f4a-de9a-46ee-a724-c4d747384ab5
---

Never invent an account, login, or test persona to drive a system. If you don't have one, **ask
for it before touching the app** — not after auth fails.

**Why:** guessed accounts fail in a way that looks like a bug, not like a wrong input. Attempting
`evan.heisler@bionichealth.com` (from the harness `userEmail`) and `dev@bionichealth.com` (a
script default) against the patient app produced a valid magic link and an
`OperationOutcomeError: Unauthorized` — which reads as a broken auth path. That triggered a long
detour through env vars, Rownd/SuperTokens flags, and network captures, when the real answer was
"those users don't exist." Evan's words: *"This is why I didn't want you automating the app. You
make these assumptions and fuck it up and waste my time and money instead of asking for help."*
The real account is in [[patient-dev-test-account]].

**How to apply:**
- Two plausible sources for a credential is not evidence — it's two guesses. Context proximity
  (an email in the system prompt, a script's default arg) is not authorization.
- When auth fails on an account you were not handed, the first hypothesis is **"this account
  isn't real"** — ask. Do not debug the environment first.
- Generalizes past accounts: any input you cannot verify and were not given (tenant, member id,
  environment, brand) is a question, not an assumption. Related: [[feedback-no-unverified-capability-gaps]].
- Cost is asymmetric: asking costs one turn; guessing costs a debugging session on Evan's dime
  and burns trust in the whole automation loop.

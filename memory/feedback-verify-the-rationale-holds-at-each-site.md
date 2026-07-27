---
name: feedback-verify-the-rationale-holds-at-each-site
description: Before generalizing a fix to sibling call sites — or filing a ticket for them — verify the REASON for the original fix actually holds at each one; a shared code shape is not a shared problem
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4ba6b93a-970f-4d79-80ec-8c4aad474326
  modified: 2026-07-27T15:49:14.798Z
---

A fix earns its place through a specific reason, not through the code shape it touches. Before
sweeping that fix to sibling call sites, or writing a ticket proposing it, check whether the
reason is true at each site. Same helper, same call shape, same "gap" on paper — different or
absent rationale means no work there.

Concrete miss: BH-3574 added support-email context because the address-not-found state
*suppresses* the follow-up Task, making the email the only artifact triage would ever receive.
I filed BH-3603 to extend that to two MWL failure states. Neither suppresses anything —
`name-email`'s `accountExists` has no identifier beyond the member's own email (already the
From address), and `setup`'s `fallback` already captures `intake_setup_magic_link_rejected`
(`setup.container.tsx:86`). Evan: "What the fuck is 3603 supposed to fix?" Canceled.

**Why:** a ticket whose premise was never checked is worse than no ticket — it looks like
verified work, consumes triage, and an agent will build it. "Five call sites share this
shape" is an observation; "five call sites share this problem" is a claim needing evidence.

**How to apply:** name the rationale for the original fix in one sentence, then test that
sentence against each candidate site before it enters a ticket or a sweep. Sites where it
fails go in a "Not in scope" section with the reason — or the ticket doesn't get filed.
Relates to [[feedback-proposals-cover-named-surface-only]],
[[feedback-no-unverified-capability-gaps]], [[feedback-never-assert-without-proof]].

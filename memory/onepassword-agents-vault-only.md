---
name: onepassword-agents-vault-only
description: "Agents may only touch the 1Password vault named `Agents`; any op:// ref outside it is a hard failure, never a convention"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-20T22:08:51.522Z
---

2026-08-20 (Agent OS migration, PR #8 secrets materialization): Evan — "agents are ONLY
ALLOWED to use the `Agents` vault. Do not expose my entire vault to agents."

**Why:** The rest of Evan's 1Password is personal. A mechanism that accepts arbitrary
`op://<vault>/…` refs exposes everything the signed-in account can read; scoping to
`op://Agents/` is the security boundary, and prose saying so doesn't enforce it.

**How to apply:** Any tooling, config, or dispatch that resolves 1Password refs rejects
vault segments other than `Agents` — enforcement in the mechanism (materializer failure +
checks/ invariant), never documentation alone. Never suggest storing agent credentials
elsewhere. Related: [[feedback-conventions-before-machinery]] does not apply to security
boundaries — this one gets machinery.

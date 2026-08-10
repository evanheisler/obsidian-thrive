---
name: feedback-draft-status-is-a-gate
description: "un-draft never gates review handling — fix/push/reply/resolve runs without asking; the gate covers only new decisions and merge"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-08-10T17:43:57.963Z
---

**Corrected 2026-08-10, overriding this memory's earlier form.** I held Leonel's and Justin's
reply packages on #996 because it was un-drafted, citing this memory. Evan: "That is the wrong
workflow. You do not block posting replies. You are not allowed to TAG me or commit to work."

**The actual rule:** review handling on a loop PR — evaluate, fix, push, reply in-thread,
resolve — is NEVER approval-gated, draft or not, human reviewer or bot. Holding replies leaves
a colleague's review unanswered for no gain (`ship-issue/SKILL.md:178,313` already said this;
this memory's earlier "un-drafted = approval-gated" reading overrode it — wrongly).

What IS still gated, always, regardless of draft state:
- Merge / un-draft (human gate).
- New decisions: design/scope choices, work Evan didn't direct ([[feedback-gate-covers-publication-not-ci-fixups]]).
- Published text constraints: no `@`-tags ever; no committing-to-future-work sentences —
  a reply states what a pushed sha already does, never what "I will" do
  ([[published-text-discipline]]: future work only as an approved Linear link).
- Replies are neutral voice, no first person (`ship-issue/SKILL.md:220`).

**How to apply:** feedback lands → dispatch handler → fix, push, reply citing the sha, resolve —
same turn, no ask. Draft the reply AFTER the fix is pushed so it describes done work. The 7-29
addendum stands: an un-draft also never revokes a live instruction.

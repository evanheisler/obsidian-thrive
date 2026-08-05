---
name: feedback-lead-with-what-changes-on-screen
description: PR descriptions and chat replies lead with the user-visible change; internal topology is cut unless it changes what someone sees
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 63cf3d8b-b10c-408c-82ed-a3610ca41c6e
  modified: 2026-08-05T22:08:11.800Z
---

Lead with what a person using the app would notice. PR #992 removed a global nav
element — five tabs became four, More moved behind the header profile avatar — and
that sentence sat third in "Behavior", after a Why about tab-slot economics and
back-bubbling mechanics, followed by two paragraphs on URL segments and deep-link
parity that no member ever sees.

**Why:** Evan reads a PR to know what shipped and what to spot-check. Route groups,
URL segments, and stack topology are diff-readable; burying the visible change under
them makes the description actively harder to use than the diff.

**How to apply:** First line of a PR body and first line of a chat reply = the
on-screen change, in the words a member would use ("the More tab is gone from the tab
bar; it's behind the profile avatar now"). Internal mechanics appear only when they
change what someone sees, or when they are the risk in the diff. Otherwise cut them.
Applies to executor and review-handler dispatch prompts too — they inherit the
default. Related: [[feedback-pr-descriptions-short]],
[[feedback-no-method-narration-to-evan]], [[feedback-updates-written-for-stakeholders]].

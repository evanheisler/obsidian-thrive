---
name: feedback-anecdotal-notes-dont-descope
description: "an issue's \"X to investigate\" aside doesn't remove that named item from agent scope — research and attempt it before deferring"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ea418338-b516-4644-a1b6-cedb3366cf46
  modified: 2026-07-23T18:39:55.667Z
---

On BH-3499 (light-mode punchlist) I deferred item 1 (glassmorphic elements render dark until scroll) because the issue text said "Evan to investigate whether there's anything we can do in the meantime... next Expo SDK upgrade." Evan corrected me: that note was anecdotal, not a scope boundary — I'm expected to research and solve the issue, item 1 included.

**Why:** a named item in a punchlist/issue is in scope by default. A parenthetical "author to investigate" or "may be fixed by a future upgrade" is *context about difficulty*, not a carve-out that assigns the work to the human. Descoping a named item is the mirror error of inventing scope — both mis-set the deliverable.

**How to apply:** treat every named item in an issue as in-scope. Research + attempt a fix (systematic-debugging, real runtime evidence for hard rendering/library bugs) before deferring. Only park an item after genuine investigation proves it blocked. See also [[feedback-locate-the-referent-first]].

**Update (BH-3499, again):** the enumerated items were also just *examples of a bug class*, not the scope boundary. Evan: "The scope was never about those specific fixes — if there is a clear violation it should also be addressed." When an issue lists specific fixes that share a root pattern (here: dark `foreground-default` text/glyph on a `brand-default` surface), the deliverable is **every clear instance of that class**, found by grepping the whole app ([[feedback-patterns-mean-whole-codebase]]) — not only the listed ones. This *reverses* my earlier read of [[feedback-proposals-cover-named-surface-only]]: that rule (leave unnamed adjacent elements alone) applies when the issue is about a specific surface; it does NOT apply when the issue is about a pattern/class, where unnamed instances are in-scope by definition. Read which kind of issue it is first. The camera badge I "correctly" parked was in fact in-scope because the issue was about the class.

---
name: feedback-name-things-as-they-appear-on-screen
description: "never use a library's or ticket's internal vocabulary with Evan — name the thing by what he sees on screen, from his seat"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fc05bed0-6454-4ff1-9c7a-fd7bc2a091e4
  modified: 2026-08-06T17:09:21.323Z
---

A third-party library's internal names are not shared language. Stream Chat calls the
background of your sent messages `--str-chat__own-message-bubble-color`; I carried "own-message
bubble fill" into four consecutive turns with Evan as if it were English. He could not parse
any of them: *"STOP CALLING IT OWN-BUBBLE FILL. I HAVE NO IDEA WHAT THE FUCK THAT MEANS."*
Rephrased as "the background color of your own sent messages in Care Team chat — the bubble on
the right side," the same content landed immediately: *"Finally, I could understand that
message."*

**Why:** the term came from the vendor's CSS variables and the ticket body, so it felt like
established vocabulary. It isn't — it's the implementation's name for the thing. Every turn
built on it was unreadable, and the failure compounded silently because the words were
*accurate*, which is exactly why I didn't notice they were meaningless. Three separate
rewrites failed before I found the actual problem was the noun, not the structure.

**How to apply:**
- Name the element the way a person using the app would point at it: "your sent messages",
  "the right-side bubble", not the token, CSS variable, or component name behind it.
- A term lifted from a vendor SDK, a generated token file, or a ticket body is suspect by
  default. If Evan hasn't used the word in this conversation, translate it before it ships.
- When a reply gets called nonsense, check the **nouns** first. Restructuring an explanation
  that rests on an unintelligible term just produces another unintelligible explanation.
- The design-system token name can follow in parentheses once the plain name is established —
  never in place of it.

Related: [[feedback-mirror-users-model-verbatim]], [[feedback-no-method-narration-to-evan]],
[[feedback-copy-names-feature-not-plumbing]], [[feedback-report-outcomes-not-plumbing]].

---
name: feedback-serve-the-rules-purpose
description: "When a constraint and its purpose diverge, serve the purpose — don't preserve the rule's literal wording at the cost of a worse outcome"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f81fc5bf-48a6-4b30-b4a1-27f125a75f47
  modified: 2026-07-29T21:26:03.207Z
---

Evan (2026-07-29), after I offered two ways to split PR #961: option A pulled the small source
slice a fingerprint change depends on into the release-branch PR; option B kept the release PR
literally dep-only and left `expo-symbols` installed-but-unused for a release cycle. I
recommended B because his stated rule was "release branches carry only fingerprint changes."
His reply: **"Again, you choose to be literal over logical. Obviously the first path is better.
Handle the FINGERPRINT BREAKING CHANGES in the release branch."**

**Why:** the rule's *purpose* is that a release branch contains exactly the work that forces a
new native runtime. The minimum source required to make a fingerprint change compile is part of
that work. Honoring the wording while shipping dead code and a deferred follow-up PR defeats
the point — and it dressed up the worse option as the compliant one.

**How to apply:** before presenting options, ask what the constraint is *for*. If one option
satisfies the wording but produces leftover work, a dead dependency, or a follow-up ticket, it
is probably not a real option — say so instead of recommending it. When both paths are still
defensible, lead with the one that serves the purpose. Related:
[[feedback-resolve-framing-dont-confirm-it]], [[feedback-no-unverified-capability-gaps]].

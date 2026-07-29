---
name: feedback-current-shape-is-not-a-requirement
description: "Consolidation means deleting a copy, not syncing copies — never treat the existing file layout as a constraint; if nothing gets deleted it isn't consolidation"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cc4f3cba-ef5c-4388-8eea-b653a84beaba
  modified: 2026-07-28T22:26:20.870Z
---

Evan, after I proposed a codegen pipeline to keep two near-identical video stylesheets in sync: "CONSOLIDATE THE FUCKING STYLESHEETS." Then, once I explained the corrected plan: "Yeah, pretty standard map method. So why the FUCK DO YOU KEEP GETTING IT WRONG."

The mechanism of the failure, repeated three times in one session on the same feature:

1. I wrote "the two stylesheets stay separate files — that split is correct" into a spec as a *given*. Nobody decided that. Two files existed because that's what got written first, and I read the existing layout as a requirement.
2. Every later design inherited it. With "two files" fixed, "consolidate" can only mean "keep them in sync" — which produces generators, mapping tables, drift tests, 1,373 lines of machinery. The actual answer, delete one file, was outside the space I had allowed myself.
3. Same shape earlier the same day: I concluded a shared theme mapping was impossible because patient's stylesheet uses different values for one variable at different scopes. True of *hand-authored* files. False the moment restructuring the files is on the table — which was the whole point of the task.

**Why:** taking the current implementation as evidence of intent turns every refactor into an accretion. The existing structure is the subject of the change, not a boundary on it. And syncing always costs more code than merging, so the machinery itself is the tell that I framed it wrong.

**How to apply:** before proposing any mechanism for duplication, ask what gets **deleted**. If the answer is "nothing, but they stay in sync now," I have designed the wrong thing — go back and merge. When two files do the same job with different local vocabularies, the standard answer is one shared file plus a short per-consumer name map, not a generator. State the diffstat direction up front: consolidation should be net-negative or close to it. Related: [[feedback-reviewer-finding-lands-in-that-pr]], [[feedback-reuse-existing-system-prove-divergence]], [[feedback-dont-dodge-endstate-to-avoid-churn]], [[feedback-no-single-use-abstractions]].

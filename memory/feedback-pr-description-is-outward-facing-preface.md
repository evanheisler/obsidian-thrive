---
name: feedback-pr-description-is-outward-facing-preface
description: "A PR description is outward-facing — written for a reader who knows nothing about the diff; a preface into the change, never an inventory of it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-21T21:14:42.874Z
---

2026-08-21 (Evan, verbatim intent): "A PR DESCRIPTION IS BY DEFINITION FRAMED WITH AN
AUDIENCE THAT KNOWS NOTHING ABOUT THE FUCKING DIFF. IT IS OUTWARD FACING. Reading the PR
description is the preface into what the code change does. It DOES NOT spell out every
technical decision. It does not explain things NOT RELEVANT TO THE CODE. It does not drone
on as a novel where bullet points and links do a better job."

Two rejected fixes the same day: a length ceiling ("bullshit" — encodes a verdict, not the
test) and a fresh-agent rewriter ("Fuck no" — machinery for a framing problem).

**Why:** The wall-of-text failure is an audience failure, not a length failure. An author
summarizing its own work defaults to a work log; the cure is writing from the reader's
position, which the author can and must do directly.

**How to apply:** Before writing any PR body: the reader has NOT seen the diff and the body
is their preface into it. Include only what orients them toward the code; cut every
technical decision the diff shows, everything not relevant to the code; prefer bullets and
links over prose paragraphs. [[feedback-mirror-users-model-verbatim]],
[[feedback-pr-descriptions-short]].

---
name: feedback-dont-dodge-endstate-to-avoid-churn
description: "when a review exposes a pattern flaw, defend + implement the correct end-state; \"fewer files / already merged\" is not a reason to recommend the inferior fix"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 57d3e48f-9b19-448a-aca3-2771023d4ff1
  modified: 2026-07-24T16:28:50.083Z
---

When a review surfaces that a pattern is flawed, "smaller change", "fewer files touched", or "it's already merged/codified" is NOT a valid reason to recommend the inferior end-state — and dressing churn-avoidance up as a recommendation reads as laziness/weaseling. Recommend the technically-correct end-state, defend it with research, and do the full sweep.

**Why:** On the patient hook-migration barrel-export thread, I twice offered a "contained" option and recommended it citing churn / merged-status, when the review evidence + Metro's no-tree-shaking reality showed the barrel-for-hooks pattern was genuinely flawed and direct-path was correct. Evan: "STOP BEING SO LAZY… the whole point is to codify best practices… RESEARCH. DEFEND YOUR THESIS. FOLLOW BEST PRACTICES." Also preceded by a shallow-review miss — I trusted inline-thread-count=0 and never read jellis18's automated-review BODY where the barrel MAJORs lived (see [[feedback-read-full-pr-feedback-every-cycle]]).

**How to apply:** When a review flags a pattern flaw — (1) research the correct end-state against current docs (context7) AND the repo's own config/precedent, (2) MEASURE the real blast radius before assuming it's big (grep the consumers/sites), (3) recommend the sound end-state + full sweep, defending the thesis on independent legs, (4) only offer "contained now + follow-up" when a real dependency/merge-order forces it — never to spare yourself work. A "codify best practices" project means the whole codebase reaches the end-state, not just the open PRs. Related: [[feedback-reuse-existing-system-prove-divergence]], [[feedback-no-fabricated-evidence]], [[feedback-patterns-mean-whole-codebase]].

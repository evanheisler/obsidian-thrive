---
name: feedback-ready-for-human-means-ai-cannot
description: "ready-for-human is ONLY for work AI cannot execute; never a parking lot for design decisions or audit findings — no audit/backlog tickets, just quick wins"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9173d154-fc85-4150-b323-25665fcdc9e9
  modified: 2026-07-22T17:37:40.798Z
---

Triage each planned item three ways, not two:
- **Executable now, no decision needed** → `ready-for-agent` + Todo. Runs.
- **Needs a human decision before work can start** (should a shared primitive gain a variant; adopt a new interaction pattern) → create it but PARK it: Backlog, NOT `ready-for-agent`, decision stated as an open question. Do not tackle until decided.
- **AI genuinely cannot execute the work** (manual on-device testing, external access, a Figma-required design) → `ready-for-human`.

`ready-for-human` is strictly the third bucket — never a parking lot for the second. A decision-blocked item is NOT ready-for-human, because AI can do the work once the decision is made.

Whether to CAPTURE the decision-blocked items as issues at all tracks the ask: a dedicated cleanup/audit project wants the full set captured (execute the no-decision ones, park the rest); a "quick wins only" ask does not want a backlog manufactured. Follow the stated project purpose.

**Why:** Evan first said "no audit tickets, quick wins only," then walked it back — "maybe I was too hasty; create the issues from the audit to finish this cleanup, but I do not want to tackle anything that requires a decision right now." The stable rule across both waffles: capture-or-not tracks project purpose; execution is gated on no-decision-needed; `ready-for-human` stays AI-cannot-do. (Origin: `/plan-project` patient UI cleanup — I'd proposed parking every primitive-extension opportunity as `ready-for-human`, which was wrong on both counts.)

**How to apply:** Before labeling `ready-for-human`, ask "can an agent execute this exact work end-to-end?" Yes → `ready-for-agent` (if no decision blocks it) or park in Backlog (if a decision does). No → `ready-for-human`. Related: [[feedback-access-control-is-agent-work]] (inverse — don't over-classify mechanical work as human), [[feedback-fresh-start-means-fresh]] (no backlog hoarding when the ask is quick-wins-only).

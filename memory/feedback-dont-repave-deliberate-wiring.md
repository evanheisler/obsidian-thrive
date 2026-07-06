---
name: feedback-dont-repave-deliberate-wiring
description: "Existing config wiring (or its absence) is often deliberate — verify it works, don't re-architect it; \"ensure X works\" never means \"make X load everywhere\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a2a406b6-28c8-478c-b453-e33f5639de36
---

Before changing how something is wired — MCP registration scope, hook placement, load
mechanics — establish why it is wired the way it is. Absence of a registration can be the
design: grafana lived in a standalone `--mcp-config` file precisely so its Docker container
only starts in sessions that need it, and I "fixed" it into user scope, starting containers
every session.

**Why:** "Ensure X still works" means verify the existing mechanism functions in the new
setup — not relocate or auto-load it. Evan: "It existed how it did for a reason and you paved
over that."

**How to apply:** When a config seems unwired or inconvenient, ask what the current mechanism
is for before changing it; state the finding and let Evan decide. Never register heavy local
(stdio/docker) MCP servers at user scope. See [[feedback-skill-placement-by-coupling]] — same
failure family: acting on my inferred design instead of the recorded one.

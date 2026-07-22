---
name: bh-linear-project-status-gotcha
description: "In the BH Linear workspace, `linear project create -s started` sets status to \"To Release\" — omit -s or use Planned for a new project"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9173d154-fc85-4150-b323-25665fcdc9e9
  modified: 2026-07-22T17:50:40.940Z
---

In the Bionic Health (BH) Linear workspace, `linear project create -s started` maps the project to status **"To Release"** — a late-stage started-type status that reads as nearly-shippable. Using it at creation misrepresents a brand-new project as ready to ship (the project board is stakeholder-visible).

For a NEW project, **omit `-s`** (take the team default) or pass **`-s planned`**. Move to "In Progress" only when work actually begins — and prefer letting the person set that, not the create call. Evan had to downgrade a freshly-created cleanup project from "To Release" to "In Progress" and was (rightly) annoyed.

BH project statuses seen in the wild: Planned, Backlog, To Release, Completed, plus In Progress. Related: [[feedback-report-outcomes-not-plumbing]], [[feedback-updates-written-for-stakeholders]] (project board state is stakeholder-facing — get it right).

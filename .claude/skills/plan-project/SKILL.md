---
name: plan-project
description: Plan a project into an autonomously-workable Linear queue — grill the shape, write the PRD, slice into ready-for-agent tracer bullets with dependencies and deploy-order. The "plan a project" entry point; its output is exactly what work-project runs.
disable-model-invocation: true
argument-hint: "<feature / idea / existing project>"
---

# Plan Project

Turn an idea into a Linear project that [`work-project`](../work-project/SKILL.md)
can execute autonomously. This is **gate #1 — the one place humans make the
decisions.** Everything `work-project` does afterward is bounded by what gets
decided here, so the quality of the autonomous run is set in this skill, not that
one.

**Core principle — earn the `ready-for-agent` label.** That label means an agent
can pick the issue up with **zero human context**. If a slice still needs a
judgment call, you haven't finished planning it — sharpen it, or mark it
`ready-for-human`. A loosely-specified `ready-for-agent` issue is the dominant way
the autonomous run goes wrong: `work-project` will either park it (best case) or
guess (worst case).

## When to Use

- Starting a feature / migration / overhaul big enough to be several PRs.
- You want the resulting issues worked hands-off by `work-project`.

**Don't use for:**
- A single, already-clear PR → open one issue and run `ship-issue`.
- An existing well-formed ticket graph → go straight to `work-project`.

## The pipeline (composed skills — don't reimplement them)

Run these in order. Each is an existing skill; this skill is the sequencer and the
handoff contract.

### 1. Shape it — `grill-with-docs`

Relentless interview (`grilling`) + `domain-modeling` until the *shape* is
concrete: domain boundaries, behaviors delivered, decisions made, decisions
deferred, known unknowns. ADRs and glossary fall out of this. **Don't drive toward
file paths / component names** — those are the executor's call, not scope.

### 2. PRD — `to-prd`

Synthesize the conversation into a PRD and write it into the Linear **project
description / overview** — the project *is* the PRD's home. **Never create a master
issue to hold the PRD or to parent the slices under.** The local plan file lives at
`docs/plans/YYYY-MM-DD-<slug>.md` and **stays local — never committed.**

### 3. Slice — `to-issues`

Break the PRD into **tracer-bullet vertical slices** — each a thin end-to-end path
through all layers, demoable on its own, not a horizontal layer. Link
`Blocked by` dependencies. **Present the full breakdown and iterate until approved
before creating anything.**

Each slice is a **direct, top-level issue in the project** (a sibling, not a child).
**Default to a main issue; never build a master→sub-issue tree, and don't fragment a
slice into sub-issues** unless it clearly contains a smaller unit worth tracking on its
own. Bias toward fewer, self-contained main issues over many fine-grained ones.

### 4. Label for autonomy

Apply the labels that decide what `work-project` may touch (see the bar below).
**Applying `ready-for-agent` IS you saying "go."** You can release the whole batch
or a few at a time.

## What makes a slice `ready-for-agent` (the bar)

All of these, or it's not ready:

- **Self-contained contract** — inputs/triggers, outputs/state-changes, and
  **done-when** (observable behavior, not test names or CI checks) all on the
  issue. An agent shouldn't need to re-read the PRD for the *contract*, only for
  *intent*.
- **Dependencies linked** — every `Blocked by` is explicit, so `work-project` can
  order and stack correctly.
- **Deploy-order annotated** — if the slice must land after another (especially
  cross-repo: patient consuming a new backend endpoint), say so: a `Blocked by`
  link **plus** a one-line "deploy after X" note. `work-project` surfaces this as
  a PR `Merge order` callout at merge time.
- **No open questions** — anything unresolved is an Open Question, which means
  it's **not** ready-for-agent yet.

## What to mark `ready-for-human` instead

These are the same things `work-project` would **park** — flag them now so it never
grabs them:

- Judgment calls, design-sensitive visual work, external access, or manual testing
  the agent can't do.
- Irreversible / precedent-setting: migrations, data mutations, a **new
  architectural pattern** (ADR-worthy), **anything touching access-control or
  security**.

Give a `ready-for-human` issue the same brief quality — note *why* it can't be
delegated.

## Handoff contract → `work-project`

Planning is done when the Linear project satisfies `work-project`'s preconditions:

- [ ] The project holds the slices as top-level issues; the PRD lives in the project
      description/overview, **not** a master issue.
- [ ] Each workable slice: `ready-for-agent` + `Todo` + self-contained contract.
- [ ] `Blocked by` dependencies linked across the graph.
- [ ] Deploy-order notes where ordering is real.
- [ ] Non-delegable slices marked `ready-for-human` with a reason.

Then: `work-project <project>`.

## Red Flags — STOP

- About to write a file path / component name / endpoint URL into a PRD or issue →
  that's implementation, the executor's call. Move to "decisions deferred" or cut.
- About to label `ready-for-agent` while an Open Question is unresolved → resolve
  it or it's not ready.
- About to create issues without presenting the full slice breakdown → present,
  iterate, then create.
- About to create a master issue for the PRD, or parent the slices under one → STOP.
  The PRD goes in the **project description**; slices are top-level project issues.
- About to commit the `docs/plans/` file → it stays local.
- About to invent an approval gate / stakeholder that doesn't exist → Thrive has no
  formal sec/legal/compliance review; the human in this session is the decider.

## Related Skills (composed)

- `grill-with-docs` — step 1 (wraps `grilling` + `domain-modeling`).
- `to-prd` — step 2.
- `to-issues` — step 3 (tracer-bullet slicing).
- `triage` — the `ready-for-agent` / `ready-for-human` taxonomy and agent-brief
  shape.
- `orchestrating-linear-work` — contract-vs-implementation discipline, deeper
  decomposition.
- `work-project` — what runs the queue this produces.

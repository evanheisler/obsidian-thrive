---
name: project-status-update
description: Use when a Linear project you lead is explicitly asking for a status update — the inbox "Write a project update…" nudge, or an overdue/at-risk update prompt. Only acts on projects whose update is currently due; never posts out of band. For projects authored by plan-project and run by work-project.
disable-model-invocation: true
argument-hint: "<Linear project name or id (the one being nudged)>"
---

# Project Status Update

Post the **status update** a Linear project is asking for. An update is a **delta
since the last one**, grounded in real issue state — not a vibe. Its job is to tell
stakeholders what moved, what's left, and **what's stuck** so they can unstick it.

**Core principle — only on demand; derive, then reality-check.** Act only on a
project whose update is **currently due** (Linear is prompting for it); never post
out of band. Build the picture from live Linear data, but the tracker **isn't ground
truth** — "Done" work gets reworked, a `blocked` label outlives its blocker — so the
lead corrects it before you draft. Health is a recommendation from the signals; **the
human confirms it, and the human posts.**

## When to Use

- You got the "Write a project update…" nudge for a project you lead.
- A led project's update is overdue / its health is being prompted.

**Don't use for:** posting an update no one asked for · issue-level updates (→
comment on the issue) · authoring or re-scoping work (→ `plan-project`) · projects
you don't lead.

## Process

### 1. Confirm the project is asking for an update

The source of truth is Linear's **`projectUpdatePrompt`** inbox notification — not a
derived date window (a reminder is anchored to a recurring day, so weeks-since-start
gives false negatives). A project is **due** when it has a `projectUpdatePrompt`
(not snoozed) and no `projectUpdate` has been posted since the latest prompt:

```bash
linear api '{ viewer { email }
  notifications(first:80) { nodes { __typename
    ... on ProjectNotification { type createdAt snoozedUntilAt
      project { id name lead { email } projectUpdates(first:1){ nodes { createdAt } } } } } } }' \
| jq -r '.data.viewer.email as $me
  | [ .data.notifications.nodes[]
      | select(.__typename=="ProjectNotification" and .type=="projectUpdatePrompt" and .snoozedUntilAt==null) ]
  | group_by(.project.id)
  | map({ name:.[0].project.name, id:.[0].project.id, lead:.[0].project.lead.email,
          lastPrompt:(max_by(.createdAt).createdAt),
          lastUpdate:(.[0].project.projectUpdates.nodes[0].createdAt) })
  | map(select(.lead==$me and (.lastUpdate==null or .lastUpdate < .lastPrompt)))
  | .[] | "\(.name)\t\(.id)\tlastUpdate=\(.lastUpdate)"'
```

**Due** = `lead.email` is you · a `projectUpdatePrompt` exists, unsnoozed · no update
since its `createdAt`.

- **Named project, due** → proceed.
- **Named project, not due** → say so and **wait** — don't draft unless the human
  says to anyway.
- **No project given** → list only the due ones and let the human pick. If none are
  due, say "nothing is asking for an update" and stop.

### 2. Re-derive state (one call — Linear is the source of truth)

```bash
linear api <<'GRAPHQL'
{ project(id: "<ID>") {
  name progress scope startedAt startDate targetDate health healthUpdatedAt
  status { name } lead { email }
  projectUpdates(first: 1) { nodes { createdAt health body } }
  issues(first: 250) { nodes {
    identifier title completedAt
    state { name type } labels { nodes { name } } } }
} }
GRAPHQL
```

`state.type` buckets the work: `completed`/`canceled` = **done**, `started` = **in
progress**, `backlog`/`unstarted`/`triage` = **remaining**. (Paginate if `issues`
hits 250.)

### 3. Reality-check the tracker (brief)

Bucket the issues by `state.type` and map labels to gates (below). Then show the
lead **one compact block** — `Done N · In progress N · Remaining N` plus the gate
lines — and ask once: *"Anything stale — reworked 'done', a 'blocked' that's
cleared, recent state changes?"* Draft from the **corrected** picture, not the raw
tracker. Keep it to that single check; don't interrogate.

| Gate | Real labels / signals | Marker |
|---|---|---|
| Blocked | `blocked`; an open `Blocked by`; `needs-info` | 🔴 |
| Needs design | `needs design` | 🎨 |
| Human-led | `human-led`, `ready-for-human` | 🧑 |
| Needs spec | `needs PRD`, `needs-brief` | 📋 |

A gate that stalls a meaningful chunk of remaining scope is the headline, not a
footnote.

### 4. Compute the delta (from the corrected picture)

- **Shipped** = issues the lead confirmed done, completed **after** the last update's
  `createdAt` (no prior update → summarize the arc; group, don't enumerate all).
- **Remaining / Next** = started + nearest unstarted, minus anything gated.
- **Duration** = now − `startedAt` (fall back to first `progressHistory` entry).
- **Pace** = current `progress` vs progress at last update vs time elapsed.

### 5. Draft, recommend health, present

Write the body in the format below. Recommend a health with one line of reasoning
(§ Health). **Present the draft + recommended health and wait.** On approval:

```bash
linear project-update create <ID> --health <onTrack|atRisk|offTrack> --body-file <path>
```

## Body format (terse bullets)

Linear's UI already shows health and progress % as chrome — **don't repeat them in
the body.** Lead with one substance line, then only the bullets that apply. Omit
empty buckets; never pad.

```
<one-line headline: where it stands + the dominant gate, if any>

✅ Shipped: <what completed since the last update>
⏳ Next: <what's actively next>
🎨 Needs design: <issues>
🔴 Blocked: <issue + why>
🧑 Human-led: <issues>
📋 Needs spec: <issues>
```

Real example (modern-header project):

```
iOS nearly done; Web/Android await design.

✅ Shipped: all iOS tabs, Documents search, slot API, cleanup
⏳ Next: iOS release, detail actions, final cleanup
🎨 Needs design: Web, Android, responsive sidebar, branded header
🔴 Blocked: iOS 26 pop-back glitch
🧑 Human-led: branded translucent header
```

## Health

- **onTrack** — steady movement; no gate stalls the critical path; target (if any)
  reachable at current pace.
- **atRisk** — a gate (design/human/blocked) holds a meaningful slice of remaining
  scope, pace stalled since last update, or target near with substantial work left.
- **offTrack** — target passed with substantial scope open, or the critical path is
  blocked with no resolution in sight.

Recommend from the signals; the human may know context the data doesn't, so confirm.

## Red Flags — STOP

- About to post for a project that isn't asking for an update → out of band; stop.
- About to run `project-update create` without showing the draft + health → present
  and wait. Posting is the human's call.
- About to restate health % / progress % in the body → that's UI chrome; cut it.
- About to claim shipped/at-risk without an issue behind it → derive or drop it.
- About to assert tracker `Done`/`blocked` as fact without the lead's reality-check →
  present the picture, get corrections, then draft.
- About to write an essay → this is bullets. Trust the reader; one line per fact.
- About to bury a 🔴/🎨/🧑 gate below narrative → gates are why the update exists.

## Related Skills

- `plan-project` / `work-project` — author and run the queue this reports on.
- `triage` — the label/state taxonomy the gate buckets come from.
- `linear-cli` — `project-update`, `project`, `api` commands.

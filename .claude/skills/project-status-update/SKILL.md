---
name: project-status-update
description: Use to post a Linear project status update on demand — for all projects you lead, or one you name. No Linear prompt required. Derives the delta from live issue state, reality-checks it with you, recommends health, and posts on your approval.
disable-model-invocation: true
argument-hint: "<Linear project name or id (optional — omit to choose scope)>"
---

# Project Status Update

Post a **status update** for a Linear project you lead. An update is a **delta
since the last one**, grounded in real issue state — not a vibe. Its job is to tell
stakeholders what moved, what's left, and **what's stuck** so they can unstick it.

**Core principle — derive, then reality-check.** On invocation, list every project
you lead, then post for **all** of them, only the ones **due**, or a **single** named
project — your pick, no Linear prompt required. Build the picture from live Linear
data, but the tracker **isn't ground truth** —
"Done" work gets reworked, a `blocked` label outlives its blocker — so the lead
corrects it before you draft. Health is a recommendation from the signals; **the
human confirms it, and the human posts.**

## When to Use

- You want to post an update for a specific project you lead.
- You want to refresh updates across all projects you lead (before a review or when
  several have gone stale).
- Linear nudged you for an update — still a valid trigger, just no longer required.

**Don't use for:** issue-level updates (→ comment on the issue) · authoring or
re-scoping work · projects you don't lead.

## Process

### 1. List led projects, then pick scope

On invocation, **first** query every active project you lead and show it as a table —
no gating, no early questions. The single call below lists each project and flags
which ones Linear is currently prompting for (`UPDATE DUE`):

```bash
linear api '{
  viewer { email }
  projects(first: 100, filter: { lead: { isMe: { eq: true } } }) {
    nodes { id name state projectUpdates(first:1){ nodes { createdAt } } } }
  notifications(first: 80) {
    nodes { __typename
      ... on ProjectNotification { type snoozedUntilAt createdAt project { id } } } }
}' | jq -r '
  .data as $d
  | ( [ $d.notifications.nodes[]
        | select(.__typename=="ProjectNotification" and .type=="projectUpdatePrompt" and .snoozedUntilAt==null) ]
      | group_by(.project.id)
      | map({ id: .[0].project.id, lastPrompt: (max_by(.createdAt).createdAt) })
      | INDEX(.id) ) as $prompts
  | ["PROJECT","UPDATE DUE","LAST UPDATE","ID"], ["-------","----------","-----------","--"],
    ( $d.projects.nodes[]
      | select(.state!="completed" and .state!="canceled")
      | . as $p
      | ($prompts[$p.id]) as $pr
      | (($p.projectUpdates.nodes[0].createdAt) // null) as $u
      | (if $pr == null then false else ($u == null or $u < $pr.lastPrompt) end) as $due
      | [ $p.name, (if $due then "yes" else "no" end), ($u // "never"), $p.id ] )
  | @tsv' | column -t -s$'\t'
```

`UPDATE DUE = yes` means the project has an unsnoozed `projectUpdatePrompt` with no
`projectUpdate` since it — i.e. Linear is asking. Render the table like:

```
PROJECT           UPDATE DUE  LAST UPDATE
Alpha migration   yes         never
Billing revamp    no          2026-06-18
Search reindex    yes         2026-05-02
```

**Then** ask **once** which branch to run:

- **All** — every project in the table.
- **Due** — only the rows marked `UPDATE DUE = yes`.
- **Single** — one named project.

Recommend **due** if any row is due, otherwise **single**. (If a project was named as
an argument, still show the table, then default the branch to **single** on it.)

For the chosen set, run steps 2–5 for **each** project **one at a time**: derive,
reality-check, draft, get approval, post — then the next. A single project is a set
of one. Never batch-post; every project earns its own reality-check and its own go.

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

Example:

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

- About to batch-post across all led projects in one shot → each project gets its own
  reality-check, draft, and go. Loop one at a time; never batch-post.
- About to run `project-update create` without showing the draft + health → present
  and wait. Posting is the human's call.
- About to restate health % / progress % in the body → that's UI chrome; cut it.
- About to claim shipped/at-risk without an issue behind it → derive or drop it.
- About to assert tracker `Done`/`blocked` as fact without the lead's reality-check →
  present the picture, get corrections, then draft.
- About to write an essay → this is bullets. Trust the reader; one line per fact.
- About to bury a 🔴/🎨/🧑 gate below narrative → gates are why the update exists.

## Requires

- The `linear` CLI, authenticated to your Linear account — the `api` and
  `project-update` subcommands used throughout.
- `jq` for shaping the query output.
- Gate labels (§ Reality-check) map to whatever label taxonomy your workspace uses;
  adjust the table to your own labels.

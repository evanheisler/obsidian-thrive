---
name: weekly-review
description: Generate an executive summary of engineering work from the past 7 days for the All Hands meeting. Pulls Linear tickets (in progress, in review, done) and merged GitHub PRs from bionic-health-app and thrive, then synthesizes a business-language summary aligned with team initiatives. Use when user asks for a weekly review, weekly summary, All Hands notes, or invokes /weekly-review.
allowed-tools: Bash(linear:*), Bash(gh:*), Bash(date:*), Bash(jq:*), Read, Write
---

# Weekly Engineering Review

Generate an **executive summary** of the team's engineering work over the past 7 days for the All Hands meeting. Audience is non-engineering leadership — translate technical work into business outcomes that ladder up to initiatives.

## The bar for the output

Bad (raw, technical, ticket-level):
> Converted 2 Azure ServiceBus scripts to Dapr Workflows to facilitate FHIR ServiceRequest sync.

Good (cohesive, outcome-framed):
> Improved the prescription ordering process to read from a common source of truth, reducing the chance of mismatched orders between systems.

If a reader can't tell *why a patient, clinician, or the business is better off*, rewrite it. If two tickets describe one larger advancement, merge them. Drop tickets that don't materially advance an initiative.

## Workflow

### 1. Establish the time window

```bash
date -u -v-7d +%Y-%m-%dT%H:%M:%SZ   # 7 days ago, UTC, ISO 8601
date -u +%Y-%m-%dT%H:%M:%SZ         # now, UTC
```

Use those two timestamps as `SINCE` and `NOW` for the rest of the run.

### 2. Pull Linear tickets

We want issues that were **active in the last 7 days** in states *in progress*, *in review*, or *done* — i.e. anything the team actually moved on, not stale backlog.

Linear's canonical state *types* are `started` and `completed` for our purposes. The workflow state *name* "In Review" sits under `started`. Filter by `updatedAt >= SINCE` to scope to this week.

Use the raw GraphQL API (the `issue list` flags don't filter by updatedAt):

```bash
linear api '
  query($since: DateTimeOrDuration!) {
    issues(
      filter: {
        updatedAt: { gte: $since }
        state: { type: { in: ["started", "completed"] } }
      }
      first: 200
      orderBy: updatedAt
    ) {
      nodes {
        identifier
        title
        description
        state { name type }
        assignee { name }
        team { key name }
        project { name }
        labels { nodes { name } }
        completedAt
        updatedAt
        url
      }
    }
  }
' --variables-json "{\"since\":\"$SINCE\"}"
```

Narrow to the user's team with `team: { key: { eq: "BH" } }` (Bionic Health). The user is also on team `OFF` (Off Shore) — exclude unless explicitly asked. To re-discover team keys: `linear team list`.

### 3. Pull GitHub activity

Two repos: `Bionic-Health/bionic-health-app` and `Bionic-Health/thrive`. Org is **case-sensitive** — `bionichealth` (lowercase) 404s. Linear team key is `BH`.

Get **merged** PRs from the last 7 days (these represent shipped work):

```bash
for repo in bionic-health-app thrive; do
  gh pr list \
    --repo "Bionic-Health/$repo" \
    --state merged \
    --search "merged:>=$SINCE_DATE" \
    --limit 100 \
    --json number,title,body,author,mergedAt,labels,url
done
```

(`SINCE_DATE` is the date portion of `SINCE`, e.g. `2026-05-01`.)

Optionally also pull PRs **opened** in the window that are still open or in review — they represent work-in-flight worth mentioning.

### 4. Cross-reference and group

For each Linear ticket, look for a linked PR (Linear identifier in PR title/body, e.g. `ENG-123`). Group related tickets+PRs into single advancements. A "cohesive advancement" might span 3 tickets and 5 PRs.

Group by **initiative or product area**, not by ticket type or assignee. Examples of groupings:
- Prescription ordering
- Patient onboarding
- Clinician scheduling
- Reliability / platform

If the data doesn't make initiative grouping obvious, ask the user once: "I see work in [areas X, Y, Z] — should I group by these, or do you have a different initiative framing?"

### 5. Synthesize the summary

Write the summary as markdown to `~/weekly-reviews/YYYY-MM-DD.md` (date = today's Friday). Create the directory if needed.

Structure:

```markdown
# Weekly Engineering Review — {Friday's date}

_Covers {SINCE_DATE} → {NOW_DATE}_

## Highlights
3–5 bullets. Each bullet is one cohesive advancement, framed as the
outcome for patients, clinicians, or the business. No ticket IDs.
No file paths. No framework names unless they're meaningful to the audience.

## By Initiative

### {Initiative or product area}
1–3 sentences on what advanced this week and why it matters. Mention
**who** benefits (patients, providers, ops, eng velocity) and **what**
changed for them. Reference the underlying tickets in a single trailing
"_Tickets:_" line — small, for the curious reader, not the headline.

### {Next initiative}
…

## In Flight
Brief mention of in-progress work that will land soon and is worth
flagging. One line each.

## Notes
- Any blockers, risks, or things leadership should know
- Anything ambiguous in the data (e.g. tickets without clear initiative mapping)
```

### 6. Style rules (strict)

**Reframe technical work as outcomes.** Ask "so what?" until you reach a sentence that means something to a non-engineer.

| Avoid                          | Prefer                                              |
| ------------------------------ | --------------------------------------------------- |
| "Migrated to Dapr Workflows"   | "Made prescription syncing more reliable"           |
| "Refactored auth middleware"   | "Reduced the chance of session-related bugs"        |
| "Added Postgres index on X"    | "Sped up the patient search by ~Nx"                 |
| "Bumped SDK to v4.6"           | (probably drop — not a highlight)                   |
| "Closed ENG-1234"              | (drop — ticket IDs don't belong in the headline)    |

**Be honest about scope.** Don't inflate a config tweak into a "platform-wide reliability improvement." Leadership notices when summaries are puffed.

**Cohesion over completeness.** It's better to skip a real ticket that doesn't fit a theme than to bolt it onto a section where it doesn't belong. Mention it in "Notes" if it matters.

**Numbers when they exist.** "Cut the 95th-percentile load time on the patient list from 3.1s to 0.9s" beats "improved patient list performance."

### 7. Hand off

After writing the file, print:
- The full summary to stdout (the user is reading this minutes before All Hands)
- The file path
- A one-line note on anything ambiguous or that the user should sanity-check

## Failure modes to avoid

- **Don't list tickets.** A bullet per ticket is not a summary, it's a backlog dump.
- **Don't use Linear/GitHub jargon as if it's news** — "merged 14 PRs" is not a highlight.
- **Don't invent initiative names.** If you can't infer the framing from the data, ask the user once before writing.
- **Don't pad.** A 5-bullet summary is better than a 15-bullet one if the 5 bullets are honest.
- **Don't include private/sensitive details** from ticket descriptions (PHI, individual patient info, customer names) — describe in aggregate.

---
title: Published-Text Discipline
summary: What an agent loop may and may not write into a PR or Linear comment, the link test that decides it, and why rules phrased around "decisions" never caught the real failure. Read before any /work-project or review-handling run.
last_updated: 2026-08-05
---

# Published-Text Discipline

**Context.** During the BH-3511/3507/3538 UI-cleanup loop (`log: 2026-08-05`) the code was
fine — every PR shipped verified, mutation-tested work, and reviewers approved it. Nearly every
correction Evan made was about **text the loop published to GitHub**, under his own account.
That surface was unpoliced while everything else had a gate.

## The rule, in the form that is checkable

> **Future work appears in published text ONLY as a link to a Linear issue Evan approved.**
> If you cannot paste a `https://linear.app/...` URL for an approved issue, the sentence does
> not go in the PR.

No link → cut it. This is mechanical and needs no judgment, which is the point — every softer
formulation failed.

**And before writing anything about work beyond the change, search Linear first.** In this
session the ticket already existed and was approved (BH-3722), and an executor still re-derived
the whole finding in a review comment and re-measured it to a *different* number (102 errors vs
the 120 already in the ticket). One link was the entire correct output. Evan on seeing it: "That
was the same issue? My fucking god. Thats even worse."

## Why the earlier phrasings didn't bite

Each ban was written around **decisions**, and every actual failure was framed as a **note**:

| What was written | What the agent thought it was doing |
| -- | -- |
| "worth its own ticket" | recording a fact |
| "belongs in a separate PR" | scoping, not deciding |
| "flagged for a follow-up rather than left implicit" | being diligent |
| measuring a cost to justify *not* doing something | showing work |

A ban on decisions sails straight past all four. It recurred **three times in one session**
(#953's verification comment, #959's lint note, #960's holdout reply) with the decision rule
already pasted into the dispatch prompts.

## The other three failures on the same surface

- **`@evanheisler` tags.** The loop posts *as* his account, so a tag is the account summoning
  itself, and it routes the item to a surface nobody mines. Banned outright.
- **A ticket asserted into existence.** A reply claimed an a11y gap was "carried into the
  post-`v2.3.0` follow-up"; no such issue existed. Nothing goes out unverified — a ticket, sha,
  `file:line`, or asserted behavior is checked *in the same turn it is written*. A rebase also
  retires the sha a reviewer would click.
- **Action items buried in review prose.** #953's verification comment ended with two items for
  Evan inside a wall of verification detail. "You cannot bury action items into rambling PR
  comments. You present them to me to decide what to do."

## What a comment is for

What this change does and why it is correct. Present facts that explain the change are fine and
often necessary — "`providers/` is outside the lint globs, which is why nothing caught this."
The moment it turns into what someone should do about that, it needs the approved link or it is
cut. Anything genuinely Evan's to decide goes in the subagent's **return to the orchestrator**,
who raises it in the session, one item per turn.

## Where enforcement actually lives

**Skill text is advisory to a subagent; the dispatch prompt is what binds.** Direct evidence
from this session: the human-reviewer reply-approval gate sat in `ship-issue/SKILL.md` all
session and four handlers walked past it, while every agent handed the no-tagging line *in its
prompt* complied, including two already mid-run. So a rule that matters goes in three places —
`work-project/SKILL.md`, `work-project/executor-prompt.md`, `ship-issue/SKILL.md` — **and** into
each dispatch prompt as it is written. The orchestrator must also check returned work for it;
subagents self-reported clean while violating it.

Evan's standing verdict on rule-writing as a remedy: "you didn't fucking follow the rules
anyway. what is the point." The honest boundary — a rule fires when it is in the prompt, and
dispatch prompts are readable, so compliance is checkable rather than trust-based.

## Related

[[work-project-orchestration-postmortem]] — the earlier run, whose failures were about state-truth
and reuse enforcement rather than published text. [[research-first-endstate-postmortem]].
Memories: `feedback-never-tag-evan-in-pr-comments`, `feedback-state-the-finding-then-ask`,
`feedback-action-items-explicit-list`, `feedback-no-fabricated-evidence`.

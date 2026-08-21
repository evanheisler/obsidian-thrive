---
name: feedback-dispatch-names-skills-never-paraphrases
description: Dispatch prompts point executors at skill FILES to read and run — never a paraphrase or format summary of the skill
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-21T20:52:49.148Z
---

2026-08-21: my ENG-99 dispatch said "PR description follows the merged write-pr format
(What/Why/How/Testing/Anything Else)" — a paraphrase. The executor never read
`os/skills/write-pr/SKILL.md`, so its brevity rules and wait-what pass never ran; PR #16
shipped a 5KB wall of text. Evan: "DO NOT PARAPHRASE A SKILL. The executor MUST RUN THE
SKILL — THAT IS WHY THE FUCKING SKILL EXISTS." Same session, same shape: pointing the
executor at the wrong vault repo instead of having it derive repo facts from the issue.

**Why:** A paraphrase strips the skill to the part I remembered — the headers survived,
the judgment rules died. Skills exist precisely so the full procedure runs without the
orchestrator's compression. [[feedback-run-prescribed-skills-not-handrolled]] applied to
dispatch prompts.

**How to apply:** Every dispatch prompt names the skill files to read-and-run by path
(repo + path for remote, absolute path for local), states they are authoritative, and
adds only deltas the skill cannot know (studio adaptations, constraints, IDs). Never
restate a skill's content. If I catch myself typing a format or procedure summary that
a skill owns, replace it with the path.

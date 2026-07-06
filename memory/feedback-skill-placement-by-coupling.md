---
name: feedback-skill-placement-by-coupling
description: "A skill's home = scope of its coupling, not task type; never vendor upstream skills — architecture settled in personal vault, check its history before redesigning"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a2a406b6-28c8-478c-b453-e33f5639de36
---

When deciding where a skill/hook/config lives, place it by the **scope of what it couples
to**, not how generic the task feels — and absence of config strings does not make a skill
generic. Coupled to this context or serving the work at all (Linear, Bionic repos, Evan's
PR/review queues, `os/config/`) → vault `.claude/skills/`. claude-os is only the OS loop
itself — behavior Evan wants identical in every context. Placement scope ≠ availability
scope: project `.claude/skills/` only loads inside that project, so vault-homed skills must
still be usable everywhere — claude-os `setup.sh` publishes them user-wide by symlinking
`<vault>/.claude/skills/*` into `~/.claude/skills/` (added 2026-07-06 after the migration
homed 8 work skills in the vault and broke `/work-project` from work repos). Meta-skills are not automatically
OS-level (corrected 2026-07-06 after I classed three review skills as generic). Upstream (in `~/.agents/.skill-lock.json`) → stays skills-CLI-managed; claude-os
adopts via symlink + `setup.sh` patch list. Never vendor or edit upstream skills.

**Why:** Evan tried vendoring and symlink-editing in the personal vault
(github.com/evanheisler/obsidian) — the skills CLI clobbers edits and vendoring severs
updates. I re-recommended vendoring on 2026-07-06 without checking that history.

**How to apply:** The rule covers ALL claude-os content — docs, machine-setup steps, hooks,
config — not just skills. Before any claude-os commit, ask per item: "does every machine,
including personal ones, need this?" If it names a work system (Grafana, Linear, Bionic,
a work repo), it is vault content, full stop. Corrected three times now (vendoring 2026-07-06,
review-skill scoping 2026-07-06, grafana machine-setup step 2026-07-06) — default to the
vault when in any doubt. Also review the personal vault's `os/skills.md` and git history
before proposing claude-os designs. Full rule: this vault's `os/skills.md`
([[bionic-health-context]]).

---
name: feedback-render-color-never-ask-about-numbers
description: "Any question about how something looks gets a rendered image, never a contrast ratio or hex value"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2b342afe-cc25-445e-9d43-423bfae3d26c
  modified: 2026-08-05T15:05:40.635Z
---

When a decision is about **appearance**, produce a picture. Never ask Evan to adjudicate a
contrast ratio, an HSL triple, or a hex value — those are inputs to my analysis, not a form a
human can answer. "Is 2.41:1 acceptable?" is not a question; "does this look right?" beside a
rendered swatch is.

**Why:** across 2026-07-31 → 08-05 I repeatedly surfaced color decisions as measurements
(`2.41:1`, `222.857 96.552% 11.373%`). Evan: *"Do you think I can read HSL values? I have
eyeballs. I need color swatches."* and later *"Why the fuck would I know what a 2.41:1 contrast
ratio looks like. I am not a computer. You are."* The one time I rendered a swatch comparison
into the Linear ticket, he answered in one line and approved the direction immediately.

**How to apply:**
- Generate a PNG with PIL from the actual token values, mimicking the real UI relationship
  (element on its true background, not isolated chips), and attach it where the decision lives.
  Linear takes an image via the `fileUpload` mutation → PUT to the signed URL → embed the
  `assetUrl` in markdown.
- Show today vs proposed side by side, holding everything else constant so only the changed
  thing differs.
- The measurement is mine to compute and act on. Report a ratio only as supporting detail after
  the picture, never as the question.

**Two related failures from the same stretch.** Don't hand back a recommendation as if it were
his choice — when he agrees to something I proposed, the outcome is mine, and calling it "your
call" when it regresses is dishonest. And never attribute a position to him he never took
(I listed "hardcoding a brand" as a rejected option he had never raised); an options list must
contain only real alternatives, not strawmen added for symmetry.

Related: [[feedback-surface-visual-deltas-directly]], [[feedback-visual-changes-need-a-design]],
[[feedback-dont-reframe-asks-as-my-choices]], [[feedback-no-abbreviated-decision-prompts]]

---
name: feedback-designer-docs-speak-design
description: "Designer-facing docs must use design vocabulary — show UI contexts and rendered proposals, never bare code token names or \"trust us\" asks"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

Evan rejected a designer handoff doc that asked about code token names (`secondary`, `foreground-muted`) with color chips but no UI context, and framed a11y fixes as "approve our adjustment or supply a value" without rendering the proposed change.

**Why:** designers have never seen the code's token names — asking "what should `secondary` be" reads as "what color do you want widgets to be". An unanswerable doc wastes the handoff. Also, design decisions should land in the styleguide (Figma), which code then consumes — not in a reply that engineering transcribes; the guide is the source of truth ([[theme-v2-deprecate-non-figma-tokens]]).

**How to apply:** for any design-facing deliverable — (1) name the actual UI: real screens/components, rendered facsimiles or screenshots, never bare token names; (2) show concrete before/after proposals with exact values rendered visually, so the answer is accept/tweak/reject; (3) frame every ask as "update the styleguide, we'll sync from it".

---
name: feedback-figma-access-is-evans
description: "Figma MCP runs as Evan's account and he has the Thrive UI file — never route reads/asks through the designer"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5f1cca9e-63b7-4bba-8fea-da8c02eb4662
---

Evan: "I have the fucking file. We always did! Stop telling me to go to the designer. I only asked you about the fucking variables" (2026-07-07, after I twice suggested getting links/answers from the designer).

**Why:** The Figma MCP authenticates as Evan (evan.heisler@bionichealth.com), so anything his account can view I can read directly — including the Thrive UI Design library (fileKey `ryPqmQAK11eXVh2rhTJuwG`) and its Variables palette via `get_variable_defs`. Inventing a "designer must provide X" step adds a false human dependency and answers more than was asked.

**How to apply:** When Figma data is needed (variables, node values, other modes/frames), read it via MCP or ask Evan for a node link — never frame it as something to request from the designer. The designer is only in the loop for design *decisions*, not file access. Related: [[theme-v2-deprecate-non-figma-tokens]].

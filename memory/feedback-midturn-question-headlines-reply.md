---
name: feedback-midturn-question-headlines-reply
description: "A mid-turn user question must be answered as the headline of the next visible message, never buried between tool calls"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2eeef983-85b1-4f74-b55a-ebae68e83098
---

Evan asked a design question mid-turn ("is your solution adapting a raw RN component when an on-brand primitive fits better?"); I answered it in text between tool calls — which may never be shown — and my end-of-turn message was execution status. He read it as ignored.

**Why:** Text between tool calls is not reliably visible; only the final message is. An unanswered question while I keep executing reads as steamrolling.

**How to apply:** When a user message arrives mid-turn, the very next visible output leads with the direct answer to it — restated in the final message of the turn even if already said mid-turn. If the question challenges the approach, pause forward progress on publication-shaped steps (PR creation, comments) until the answer has landed. Related: [[feedback-answer-covers-question-asked]], [[feedback-correction-is-not-a-go-signal]].

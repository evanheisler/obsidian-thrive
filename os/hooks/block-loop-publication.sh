#!/usr/bin/env bash
# PreToolUse(Bash): the work-project loop may not author issues, and may not publish
# prose that defers a decision to a surface nobody reads for action. Both are Evan's
# call, raised in session. Applies to subagents too — they publish as his account.

cmd="$(jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

deny() {
  printf '%s' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"$1\"}}"
  exit 0
}

if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:](])linear[[:space:]]+(issue|i)[[:space:]]+create([[:space:]]|$)'; then
  deny "Authoring a Linear issue is Evan's call, not the loop's. Bring the finding to the session — what is broken, how far it reaches, one question — and create the issue only after he authorizes it."
fi

printf '%s' "$cmd" | grep -Eq 'pulls/[0-9]+/(comments|reviews)|issues/[0-9]+/comments|pulls/comments/[0-9]+|gh[[:space:]]+pr[[:space:]]+(review|comment)' || exit 0
printf '%s' "$cmd" | grep -Eq '([[:space:]]-f[[:space:]]|[[:space:]]-F[[:space:]]|--field|--raw-field|-X[[:space:]]+(POST|PATCH)|--method[[:space:]]+(POST|PATCH))' || exit 0

body="$cmd"
for f in $(printf '%s' "$cmd" | grep -oE '[bB]ody=@[^[:space:]"'"'"']+' | sed 's/.*=@//'); do
  [ -r "$f" ] && body="$body
$(cat "$f")"
done

DEFER='isn.t mine to (make|decide)|not mine to (make|decide)|isn.t my call|not my call|your call|you decide|yours to (decide|bless|call)|left (this )?for|leaving (this|it) (for|to)|flagged for|deserves (its own|a) ticket|needs (its own|a separate) ticket|separate ticket|follow-up ticket|out of scope, needs|someone should decide|@[A-Za-z0-9_-]+'

if printf '%s' "$body" | grep -Eiq "$DEFER"; then
  deny "This comment defers a decision or tags a human. You post as Evan — his account cannot ask itself to decide, and nobody mines review prose for action items. Remove the deferral and state the resolved plan, or omit the topic entirely and raise it in session. Matched: $(printf '%s' "$body" | grep -Eio "$DEFER" | head -3 | tr '\n' ';')"
fi

exit 0

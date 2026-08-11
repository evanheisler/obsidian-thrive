#!/usr/bin/env bash
# PreToolUse(Bash): loop publications post under the human's account. `linear issue
# create` ASKS — it is a designed human checkpoint. Tainted body text DENIES instead:
# a fast-fail lets the agent correct its own text without prompting the human.

cmd="$(jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

confirm() {
  printf '%s' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\"$1\"}}"
  exit 0
}

deny() {
  printf '%s' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"$1\"}}"
  exit 0
}

if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:](])linear[[:space:]]+(issue|i)[[:space:]]+create([[:space:]]|$)'; then
  confirm "Authoring a Linear issue commits your queue to new scope. Approve only if you asked for this issue — an agent reaching it on its own should have raised the finding in session instead."
fi

is_publish=0
if printf '%s' "$cmd" | grep -Eq 'pulls/[0-9]+/(comments|reviews)|issues/[0-9]+/comments|pulls/comments/[0-9]+|issues/comments/[0-9]+|pulls/[0-9]+/reviews/[0-9]+|pulls/[0-9]+["'"'"']?[[:space:]]' ; then
  printf '%s' "$cmd" | grep -Eq '([[:space:]]-f[[:space:]]|[[:space:]]-F[[:space:]]|--field|--raw-field|-X[[:space:]]+(POST|PATCH|PUT)|--method[[:space:]]+(POST|PATCH|PUT))' && is_publish=1
fi
printf '%s' "$cmd" | grep -Eq 'graphql' && \
  printf '%s' "$cmd" | grep -Eq 'addComment|addPullRequestReview|addPullRequestReviewComment|addPullRequestReviewThreadReply|submitPullRequestReview|updatePullRequestReview|updateIssueComment|updatePullRequestReviewComment|updateIssue\b|updatePullRequest|createIssue|addDiscussionComment|minimizeComment' && is_publish=1
printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:](])gh[[:space:]]+(pr|issue)[[:space:]]+(edit|comment|review)([[:space:]]|$)' && is_publish=1
printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:](])linear[[:space:]]+(issue|i)?[[:space:]]*comment([[:space:]]|$)' && is_publish=1

[ "$is_publish" = "1" ] || exit 0

# `body=@path` tokens are dropped so the path itself never trips the mention rule.
scan="$(printf '%s' "$cmd" | sed -E 's/[bB]ody=@[^[:space:]"'"'"']+//g')"
for f in $(printf '%s' "$cmd" | grep -oE '[bB]ody=@[^[:space:]"'"'"']+' | sed 's/.*=@//'); do
  [ -r "$f" ] && scan="$scan
$(cat "$f")"
done

# Backticked spans never notify; anything left that looks like a mention does —
# including bare npm scopes, which ping the scope's real GitHub account.
stripped="$(printf '%s' "$scan" | sed -E 's/`[^`]*`//g')"
MENTION='(^|[^A-Za-z0-9`=._-])@[A-Za-z0-9][A-Za-z0-9_-]*'
if printf '%s' "$stripped" | grep -Eq "$MENTION"; then
  deny "BLOCKED: published text may not @-mention anyone — it posts under the human's account and can summon people outside the org (bare @scope/pkg pings the package author's real GitHub account). Fix your text and retry: wrap package names in backticks (\`@scope/pkg\`), drop the @ from handles, and remove people-tags entirely — if a tag is ever genuinely needed, the human posts it himself. Matched: $(printf '%s' "$stripped" | grep -Eo "$MENTION" | sort -u | head -3 | tr '\n' ';')"
fi

DEFER='isn.t mine to (make|decide)|not mine to (make|decide)|isn.t my call|not my call|your call|you decide|yours to (decide|bless|call)|leaving (this|it) (for|to|open for)|left (this|it) for|flagged for|deserves (its own|a) ticket|needs (its own|a separate) ticket|separate ticket|follow-up ticket|out of scope, needs|someone should decide'
if printf '%s' "$stripped" | grep -Eiq "$DEFER"; then
  deny "BLOCKED: this body defers a decision to a surface nobody reads for action, and it posts under the human's account. Fix your text and retry: state the resolved plan in the first person, or cut the topic and raise it in your return to the orchestrator. Matched: $(printf '%s' "$stripped" | grep -Eio "$DEFER" | sort -u | head -3 | tr '\n' ';')"
fi

exit 0

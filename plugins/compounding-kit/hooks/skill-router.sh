#!/usr/bin/env bash
# UserPromptSubmit hook: route the task to its SKILLS.md chain.
# The harness decides which chain applies, not the model's memory. Injects the
# matching section of SKILLS.md once per session and class, and logs the routing
# (never the prompt text) so adherence can be measured later.
#
# Config:
#   SKILLS.md   : $COMPOUNDING_SKILLS_MD, default ~/.claude/SKILLS.md
#   rules file  : ~/.claude/skill-router.rules (one line: class|section|regex),
#                 default rules below if the file is missing
set -uo pipefail
IN="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0
prompt=$(printf '%s' "$IN" | jq -r '.prompt // ""' 2>/dev/null) || exit 0
session=$(printf '%s' "$IN" | jq -r '.session_id // ""' 2>/dev/null)
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SKILLS="${COMPOUNDING_SKILLS_MD:-$CLAUDE_DIR/SKILLS.md}"
[ -f "$SKILLS" ] || exit 0
lp=$(printf '%s' "$prompt" | tr '[:upper:]' '[:lower:]')

# Skip relayed agent reports, slash commands and very short prompts ("ok", "do it").
printf '%s' "$lp" | grep -qE '<agent-message|subagent hand-back|<task-notification|<command-name|<system-reminder' && exit 0
printf '%s' "$lp" | grep -qE '^[[:space:]]*/' && exit 0
[ "$(printf '%s' "$lp" | wc -w | tr -d ' ')" -lt 4 ] && exit 0

RULES_FILE="$CLAUDE_DIR/skill-router.rules"
if [ -f "$RULES_FILE" ]; then
  RULES="$(grep -v '^#' "$RULES_FILE")"
else
  # class|SKILLS.md section number|pattern. Order = priority. Max two classes per prompt.
  RULES='website|2|website|webseite|landing ?page|netlify|vercel|deploy|\bseo\b|sitemap|search console
client-ui|3|client app|kunden-?app|\bui\b|screen|dashboard
content|4|linkedin|\bblog|newsletter|whitepaper|\bposts?\b|artikel|beitrag|\bcontent\b|video-?skript
visuals|5|\bbild|\bimage|illustration|diagram|grafik|\bdeck\b|präsentation|\bslides?\b|folien|\bvideo\b|\bicon
sales|6|offerte|angebot|\bquote\b|proposal|\bdeal\b|\blead|meeting prep|sales call|discovery|\bkunde|\bclient\b|\bpitch
knowledge|7|knowledge base|wissensdatenbank|\bwiki|\bkb\b|know-?how|ingest|recherch|research|rechnung|invoice|finanzen|finance
software|1|\bapp\b|feature|\bbug|\bfix|\bscript|skript|\bbuild|implement|refactor|\btest|\bjob\b|cron|python|server|\bapi\b|\bcode\b|function|\bhook|automat'
fi

matched=""; n=0
while IFS='|' read -r cls sec pat; do
  [ -z "$cls" ] && continue
  if printf '%s' "$lp" | grep -qE "$pat"; then
    matched="$matched $cls:$sec"; n=$((n+1)); [ $n -ge 2 ] && break
  fi
done <<< "$RULES"
[ -z "$matched" ] && exit 0

CACHE="${COMPOUNDING_HOME:-$HOME/.compounding}/cache/skill-router"; mkdir -p "$CACHE"
ctx=""; logged=""
set -f   # no glob expansion of the matched list
for m in $matched; do
  cls="${m%%:*}"; sec="${m##*:}"
  key=$(printf '%s:%s' "$session" "$cls" | shasum | cut -c1-16)
  [ -f "$CACHE/$key" ] && continue       # already routed this class in this session
  touch "$CACHE/$key"
  body=$(awk -v s="## $sec. " 'index($0,s)==1{p=1} p&&/^## /&&index($0,s)!=1{exit} p' "$SKILLS")
  [ -z "$body" ] && continue
  ctx="$ctx
--- $cls (SKILLS.md section $sec) ---
$body"
  logged="$logged $cls"
done
set +f
[ -z "$ctx" ] && exit 0

jq -nc --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" --arg s "$session" --arg c "${logged# }" '{ts:$ts,session:$s,classes:$c}' >> "$CACHE/log.jsonl"

read -r -d '' head <<'EOF2'
SKILL ROUTER (harness hook, from SKILLS.md). The prompt looks like the task class(es) below. Run the chain's skills with the Skill tool in the given order; gates are mandatory; the universal gate (verify before any "done") comes last. Skills written /name are user-only: the user types them, you do not. If the task is really something else, ignore this block. Do not mention the router or announce skills.
EOF2
jq -n --arg c "$head$ctx" '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",additionalContext:$c}}'
exit 0

#!/usr/bin/env bash
# UserPromptSubmit hook: when the user says something "feels off", inject the taste-interview flow.
prompt=$(jq -r '.prompt // ""' | tr '[:upper:]' '[:lower:]')

# skip relayed subagent reports
echo "$prompt" | grep -qE '<agent-message|subagent hand-back|<task-notification' && exit 0

pattern="feels? off|looks? off|sounds? off|reads? off|something'?s off|is off\b|not quite right|doesn'?t feel right|don'?t like (it|this|the)|feels? (wrong|weird|generic|flat|cheap)|taste check|passt (mir )?nicht|stimmt (irgendwie )?nicht|irgendwas stimmt|wirkt (komisch|billig|generisch|falsch)|fühlt sich .*(falsch|komisch) an|gefällt mir nicht|nicht ganz (richtig|stimmig)"

echo "$prompt" | grep -Eq "$pattern" || exit 0

read -r -d '' ctx <<'EOF2'
TASTE INTERVIEW triggered: the user said something feels off. Skip this if they are talking about a bug, a wrong fact or broken code; it is only for taste (copy, design, tone, visuals).

1. Read the memory file feedback_taste_rules.md first (if it exists). Do not change the piece yet.
2. Ask 5 to 6 short questions with AskUserQuestion (two rounds, max 4 per call). Every question has concrete clickable options. Cover:
   - Where exactly it is off (which part, line or element)
   - What kind of off (too generic, too loud, too flat, too busy, too polite, off-brand, unclear point)
   - Which direction (axes like bolder vs calmer, denser vs airier, warmer vs sharper, more vs less formal)
   - Who should feel what when they see it
   - A reference they like, or what must stay untouched
   - How far to go (small tweak vs real rethink)
3. Then show 2 to 3 options (A, B, C), each differing in ONE thing they named, plus one WILDCARD that breaks an existing taste rule on purpose. Show them side by side, short.
4. After they pick, name the rule in one plain line and save it to feedback_taste_rules.md: rule, kind (never | usually), context (copy | design | linkedin | website | deck | all), date, override count. Hard cap 20 rules: a new one replaces the weakest. If they pick the wildcard, narrow or delete the rule it broke. A rule broken 3 times gets rewritten or dropped.
EOF2

jq -n --arg c "$ctx" '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",additionalContext:$c}}'

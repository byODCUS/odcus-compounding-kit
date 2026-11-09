#!/usr/bin/env bash
# SessionStart hook: show the learning-loop rule once per session.
# Part of the compounding kit. Exits silently if the CLI is missing.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="$ROOT/scripts/learning.sh"
[ -f "$CLI" ] || exit 0
OPEN="$(bash "$CLI" count 2>/dev/null || echo 0)"
MSG="Learning loop active. When a working instruction (skill, job, rule file, CLAUDE.md) turns out incomplete, wrong or clumsy in this session, record it AT THAT MOMENT:
  bash \"$CLI\" add <target> 'What was missing' 'Concrete patch proposal'
Single quotes around the texts (they may contain backticks). <target> = skill name, job id or rule file (for example my-skill, nightly-blog, CLAUDE.md). Only real gaps in instructions: facts go to memory, dated tasks go to followup.sh. The weekly review turns open learnings into patch proposals. Open learnings right now: $OPEN."
MSG="$MSG" python3 -c '
import json, os
print(json.dumps({"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":os.environ["MSG"]}}, ensure_ascii=False))
'
exit 0

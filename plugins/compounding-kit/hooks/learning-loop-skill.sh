#!/usr/bin/env bash
# PostToolUse hook (matcher: Skill): right after a skill ran, ask once per
# session and skill whether the instruction was enough. Part of the compounding kit.
set -uo pipefail
IN="$(cat)"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="$ROOT/scripts/learning.sh"
[ -f "$CLI" ] || exit 0
HOOK_IN="$IN" HOOK_CLI="$CLI" python3 <<'PY'
import hashlib, json, os, pathlib, shlex, sys
try:
    data = json.loads(os.environ["HOOK_IN"])
except Exception:
    sys.exit(0)
skill = (data.get("tool_input") or {}).get("skill") or ""
session = data.get("session_id") or ""
if not skill:
    sys.exit(0)
key = hashlib.sha1(f"{session}:{skill}".encode()).hexdigest()[:16]
home = pathlib.Path(os.environ.get("COMPOUNDING_HOME") or (pathlib.Path.home() / ".compounding"))
stamp = home / "cache" / "learning-loop" / key
if stamp.exists():
    sys.exit(0)
stamp.parent.mkdir(parents=True, exist_ok=True)
stamp.touch()
msg = (f'Skill "{skill}" just ran. If its instruction missed something (a step, a wrong assumption, '
       f'an edge case), record it now, not later: '
       f'bash "{os.environ["HOOK_CLI"]}" add {shlex.quote(skill)} \'What was missing\' \'Patch proposal\' (single quotes). '
       f'If everything fit, ignore this line and do not mention it.')
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": msg}}, ensure_ascii=False))
PY
exit 0

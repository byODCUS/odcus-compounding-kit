#!/usr/bin/env bash
# ============================================================================
# learning.sh - learning loop: record gaps in working instructions
#
# Store: $COMPOUNDING_HOME/learnings.jsonl (one JSON object per line).
#
# Memory    = a fact to remember.
# Follow-up = a task with a date.
# Learning  = a working instruction (skill, job, rule) was incomplete or wrong.
#             The goal is a patch to that file.
#
#   learning.sh add <target> "gap" ["proposal"]   record
#   learning.sh list [target]                     open entries
#   learning.sh count                             number of open entries
#   learning.sh json                              open entries as JSON
#   learning.sh patched <id> ["note"]             mark as applied
#   learning.sh reject <id> ["reason"]            mark as rejected
#
# <target> = skill name, job id or rule file (my-skill, nightly-blog, CLAUDE.md).
# ============================================================================
set -uo pipefail
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
FILE="$LEARNINGS_FILE"
CMD="${1:-list}"

case "$CMD" in
  add)
    LN_TARGET="${2:?target missing (skill, job or rule)}"
    LN_GAP="${3:?gap missing}"
    LN_PROPOSAL="${4:-}"
    LN_TARGET="$LN_TARGET" LN_GAP="$LN_GAP" LN_PROPOSAL="$LN_PROPOSAL" LN_FILE="$FILE" python3 - <<'PY'
import json, os, secrets, time
from datetime import date
rec = {
    "id": "l-" + format(int(time.time()), "x") + secrets.token_hex(2),
    "created": date.today().isoformat(),
    "target": os.environ["LN_TARGET"],
    "gap": os.environ["LN_GAP"],
    "proposal": os.environ.get("LN_PROPOSAL", ""),
    "host": os.uname().nodename,
    "status": "open",
}
with open(os.environ["LN_FILE"], "a", encoding="utf-8") as f:
    f.write(json.dumps(rec, ensure_ascii=False) + "\n")
print(f"learning recorded: {rec['id']} [{rec['target']}] {rec['gap']}")
PY
    ;;
  list|json|count)
    LN_FILE="$FILE" LN_MODE="$CMD" LN_FILTER="${2:-}" python3 - <<'PY'
import json, os
path, mode, flt = os.environ["LN_FILE"], os.environ["LN_MODE"], os.environ.get("LN_FILTER", "")
items = []
if os.path.exists(path):
    for line in open(path, encoding="utf-8"):
        line = line.strip()
        if not line:
            continue
        try:
            r = json.loads(line)
        except json.JSONDecodeError:
            continue
        if r.get("status") != "open":
            continue
        if flt and r.get("target") != flt:
            continue
        items.append(r)
items.sort(key=lambda r: (r.get("target", ""), r.get("created", "")))
if mode == "count":
    print(len(items))
elif mode == "json":
    print(json.dumps(items, ensure_ascii=False, indent=2))
else:
    for r in items:
        print(f"{r['id']}  {r['created']}  [{r['target']}]  {r['gap']}")
        if r.get("proposal"):
            print(f"{'':>16}-> {r['proposal']}")
PY
    ;;
  patched|reject)
    LN_ID="${2:?id missing}" LN_NOTE="${3:-}" LN_FILE="$FILE" LN_NEW="$CMD" python3 - <<'PY'
import json, os, sys
from datetime import date
path, lid, new = os.environ["LN_FILE"], os.environ["LN_ID"], os.environ["LN_NEW"]
status = "patched" if new == "patched" else "rejected"
lines, hit = [], False
if not os.path.exists(path):
    print("learnings.jsonl does not exist"); sys.exit(1)
for n, line in enumerate(open(path, encoding="utf-8"), 1):
    line = line.strip()
    if not line:
        continue
    try:
        r = json.loads(line)
    except json.JSONDecodeError:
        print(f"warning: line {n} is not valid JSON, left unchanged", file=sys.stderr)
        lines.append(line)
        continue
    if r.get("id") == lid and r.get("status") == "open":
        r["status"] = status
        r["closed"] = date.today().isoformat()
        if os.environ.get("LN_NOTE"):
            r["note"] = os.environ["LN_NOTE"]
        hit = True
    lines.append(json.dumps(r, ensure_ascii=False))
if not hit:
    print(f"no open learning with id {lid}"); sys.exit(1)
with open(path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print(f"{status}: {lid}")
PY
    ;;
  *)
    echo 'usage: learning.sh add <target> "gap" ["proposal"] | list [target] | count | json | patched <id> ["note"] | reject <id> ["reason"]'
    exit 1
    ;;
esac

#!/usr/bin/env bash
# ============================================================================
# followup.sh - follow-ups with a due date. Store: $COMPOUNDING_HOME/followups.jsonl
#
#   followup.sh add "Text" YYYY-MM-DD   create
#   followup.sh list                    all open, by due date
#   followup.sh due                     due today or overdue
#   followup.sh done <id>               close
#
# Rule for Claude sessions (see CLAUDE.md template): everything with a date goes
# here, not only into prose. followups-due.sh surfaces due items every morning.
# ============================================================================
set -uo pipefail
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
FILE="$FOLLOWUPS_FILE"
CMD="${1:-list}"

case "$CMD" in
  add)
    TEXT="${2:?text missing}"; DUE="${3:?due date YYYY-MM-DD missing}"
    python3 -c "import datetime,sys; datetime.date.fromisoformat(sys.argv[1])" "$DUE" 2>/dev/null \
      || { echo "invalid date: $DUE. Usage: followup.sh add \"<text>\" <YYYY-MM-DD>"; exit 1; }
    FU_TEXT="$TEXT" FU_DUE="$DUE" FU_FILE="$FILE" python3 - <<'PY'
import json, os, secrets, time
from datetime import date
rec = {
    "id": "f-" + format(int(time.time()), "x") + secrets.token_hex(2),
    "created": date.today().isoformat(),
    "due": os.environ["FU_DUE"],
    "text": os.environ["FU_TEXT"],
    "status": "open",
}
with open(os.environ["FU_FILE"], "a", encoding="utf-8") as f:
    f.write(json.dumps(rec, ensure_ascii=False) + "\n")
print(f"created: {rec['id']} (due {rec['due']}) {rec['text']}")
PY
    ;;
  list|due)
    FU_FILE="$FILE" FU_MODE="$CMD" python3 - <<'PY'
import json, os, sys
from datetime import date
path, mode = os.environ["FU_FILE"], os.environ["FU_MODE"]
if not os.path.exists(path):
    sys.exit(0)
items = []
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
    if mode == "due" and r.get("due", "9999") > date.today().isoformat():
        continue
    items.append(r)
items.sort(key=lambda r: r.get("due", "9999"))
today = date.today().isoformat()
for r in items:
    mark = "OVERDUE" if r["due"] < today else ("TODAY" if r["due"] == today else "")
    print(f"{r['id']}  {r['due']}  {mark:<8} {r['text']}")
PY
    ;;
  done)
    FU_ID="${2:?id missing}" FU_FILE="$FILE" python3 - <<'PY'
import json, os, sys
from datetime import date
path, fid = os.environ["FU_FILE"], os.environ["FU_ID"]
lines, hit = [], False
for line in open(path, encoding="utf-8"):
    line = line.strip()
    if not line:
        continue
    try:
        r = json.loads(line)
    except ValueError:
        lines.append(line)  # keep unknown lines untouched
        continue
    if r.get("id") == fid and r.get("status") == "open":
        r["status"] = "done"
        r["done_ts"] = date.today().isoformat()
        hit = True
    lines.append(json.dumps(r, ensure_ascii=False))
if not hit:
    print(f"no open follow-up with id {fid}")
    sys.exit(1)
with open(path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print(f"done: {fid}")
PY
    ;;
  *)
    echo "usage: followup.sh add \"Text\" YYYY-MM-DD | list | due | done <id>"
    exit 1
    ;;
esac

#!/usr/bin/env bash
# ============================================================================
# log-run.sh - append one job-run record to the run log ($COMPOUNDING_HOME/logs/runs.jsonl)
#
#   log-run.sh <job-id> <status> <started-iso> <summary> [detail-json-file]
#
#   status   success | failed | partial   (partial = ran, but something waits for a human)
#
# The run log is the single feed a dashboard reads. One JSON object per line.
# ============================================================================
set -euo pipefail
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
RUNS="$RUNS_FILE"

JOB="${1:?job-id}"; STATUS="${2:?status}"; STARTED="${3:?started}"; SUMMARY="${4:?summary}"
DETAIL_FILE="${5:-}"

JOB="$JOB" STATUS="$STATUS" STARTED="$STARTED" SUMMARY="$SUMMARY" DETAIL_FILE="$DETAIL_FILE" \
python3 - "$RUNS" <<'PY'
import json, os, sys, time
from datetime import datetime, timezone

record = {
    "ts": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "job": os.environ["JOB"],
    "status": os.environ["STATUS"],
    "started": os.environ["STARTED"],
    "summary": os.environ["SUMMARY"],
    "host": os.uname().nodename,
}
detail_file = os.environ.get("DETAIL_FILE", "")
if detail_file and os.path.exists(detail_file):
    try:
        with open(detail_file) as f:
            record["detail"] = json.load(f)
    except Exception as e:
        record["detail_error"] = str(e)

line = json.dumps(record, ensure_ascii=False) + "\n"
# A synced drive can lock the file for a moment. Retry, then spool locally.
last = None
for attempt in range(3):
    try:
        with open(sys.argv[1], "a", encoding="utf-8") as f:
            f.write(line)
        sys.exit(0)
    except OSError as exc:
        last = exc
        time.sleep(5)
spool = os.path.join(os.environ.get("XDG_STATE_HOME") or os.path.expanduser("~/.local/state"), "compounding", "runs-spool.jsonl")
os.makedirs(os.path.dirname(spool), exist_ok=True)
with open(spool, "a", encoding="utf-8") as f:
    f.write(line)
print(f"log-run: runs.jsonl not writable ({last}), line spooled to {spool}", file=sys.stderr)
sys.exit(3)
PY

#!/usr/bin/env bash
# followups-due.sh - surface due follow-ups each morning (cron, e.g. 07:10).
# Due or overdue items give a YELLOW (partial) run record, none gives a green one.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

DUE="$(bash "$SCRIPT_DIR/followup.sh" due)"
if [ -n "$DUE" ]; then
  N="$(echo "$DUE" | wc -l | tr -d ' ')"
  LIST="$(echo "$DUE" | awk '{$1=""; $2="(" $2 ")"; sub(/^ /,""); print}' | paste -sd'|' - | sed 's/|/ · /g' | cut -c1-220)"
  STATUS="partial"; SUMMARY="$N follow-up(s) due: $LIST"
else
  STATUS="success"; SUMMARY="no follow-ups due"
fi

echo "=== followups: $STATUS - $SUMMARY"
bash "$SCRIPT_DIR/log-run.sh" followups "$STATUS" "$STARTED" "$SUMMARY" || true
exit 0

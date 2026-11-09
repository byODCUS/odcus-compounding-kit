#!/usr/bin/env bash
# ============================================================================
# run-logged.sh - cron wrapper that records any job into the run log
#
#   run-logged.sh <job-id> <command> [args...]
#
# Records start time, exit status and the command's last output line as the
# summary via log-run.sh. stdout/stderr pass through unchanged, so existing
# ">> logfile" redirections in the crontab keep working.
# ============================================================================
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOB="${1:?job-id}"; shift

STARTED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
OUT="$(mktemp)"
trap 'rm -f "$OUT"' EXIT
"$@" 2>&1 | tee "$OUT"
RC=${PIPESTATUS[0]}

SUMMARY="$(grep -v '^\s*$' "$OUT" | tail -1 | cut -c1-300 || true)"
[ -n "$SUMMARY" ] || SUMMARY="(no output)"

if [ "$RC" -eq 0 ]; then STATUS="success"; else STATUS="failed"; SUMMARY="exit $RC: $SUMMARY"; fi
bash "$SCRIPT_DIR/log-run.sh" "$JOB" "$STATUS" "$STARTED" "$SUMMARY" || true
exit "$RC"

#!/usr/bin/env bash
# Shared paths for the compounding kit. Source this; do not run it.
# Everything the loops write lives under COMPOUNDING_HOME (default ~/.compounding).
# Put that folder on a synced drive if two machines share the loops.
COMPOUNDING_HOME="${COMPOUNDING_HOME:-$HOME/.compounding}"
LEARNINGS_FILE="$COMPOUNDING_HOME/learnings.jsonl"
FOLLOWUPS_FILE="$COMPOUNDING_HOME/followups.jsonl"
LOGS_DIR="$COMPOUNDING_HOME/logs"
RUNS_FILE="$LOGS_DIR/runs.jsonl"
REPORTS_DIR="$COMPOUNDING_HOME/reports"
umask 077   # learnings, reports and run logs are private to the user
mkdir -p "$COMPOUNDING_HOME" "$LOGS_DIR" "$REPORTS_DIR"

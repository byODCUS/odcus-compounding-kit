#!/usr/bin/env bash
# ============================================================================
# setup.sh - first-time setup of the compounding kit on this machine.
# Creates the store, copies templates where nothing exists yet, checks tools,
# and prints the cron lines. It never installs cron entries or touches secrets.
# Safe to re-run: existing files are never overwritten (a .template copy is
# placed next to them instead).
# ============================================================================
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
. "$SCRIPT_DIR/env.sh"
T="$ROOT/templates"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$CLAUDE_DIR" "$COMPOUNDING_HOME/jobs"

ok()   { printf '  [ok]   %s\n' "$*"; }
todo() { printf '  [todo] %s\n' "$*"; }
place() { # place <template> <target>
  if [ -e "$2" ]; then
    cp "$1" "$2.template"; ok "$2 exists, template saved as $2.template"
  else
    cp "$1" "$2"; ok "created $2"
  fi
}

echo "compounding kit setup"
echo "store: $COMPOUNDING_HOME"
touch "$LEARNINGS_FILE" "$FOLLOWUPS_FILE" "$RUNS_FILE"

echo "1. tools"
for t in claude jq python3 git; do
  if command -v "$t" >/dev/null 2>&1; then ok "$t"; else todo "install $t"; fi
done

echo "2. files"
place "$T/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
place "$T/SKILLS.md" "$CLAUDE_DIR/SKILLS.md"
place "$T/skill-router.rules" "$CLAUDE_DIR/skill-router.rules"

echo "3. memory folder (needed by memory-review.sh)"
if ls -d "$CLAUDE_DIR"/projects/*/memory >/dev/null 2>&1; then
  for d in "$CLAUDE_DIR"/projects/*/memory; do ok "candidate MEMORY_DIR=$d"; done
else
  todo "no memory folder yet; start one Claude Code session in your work folder, then re-run"
fi
if [ ! -f "$COMPOUNDING_HOME/MEMORY.md.example" ]; then
  cp "$T/MEMORY.md" "$COMPOUNDING_HOME/MEMORY.md.example"
  cp "$T/memory-example.md" "$COMPOUNDING_HOME/memory-example.md"
  cp "$T/memory-hub-example.md" "$COMPOUNDING_HOME/memory-hub-example.md"
  ok "memory examples copied to $COMPOUNDING_HOME"
fi

echo "4. headless auth for jobs"
AUTH="$HOME/.config/compounding/claude-auth.env"
if [ -f "$AUTH" ]; then
  ok "$AUTH present"
  MODE="$(stat -f %Lp "$AUTH" 2>/dev/null || stat -c %a "$AUTH" 2>/dev/null)"
  [ "$MODE" = "600" ] || todo "chmod 600 $AUTH (now $MODE)"
  grep -q '^export CLAUDE_CODE_OAUTH_TOKEN=' "$AUTH" || todo "the line in $AUTH must start with 'export ' or cron jobs will not see the token"
else
  todo "run: claude setup-token   then store it as   export CLAUDE_CODE_OAUTH_TOKEN=...   in $AUTH (chmod 600). Note the expiry date as a follow-up."
fi

echo "5. schedule (copy what you want into crontab -e; nothing is installed for you)"
KIT_ROOT="$ROOT" KIT_HOME="$COMPOUNDING_HOME" python3 -c '
import os, sys
t = open(sys.argv[1], encoding="utf-8").read()
t = t.replace("__KIT__", os.environ["KIT_ROOT"]).replace("__HOME__", os.environ["KIT_HOME"]).replace("__USERHOME__", os.path.expanduser("~"))
print(t, end="")' "$T/crontab.example"

echo "6. smoke test"
ID=$(bash "$SCRIPT_DIR/learning.sh" add setup "smoke test entry" "none" | sed -n 's/.*: \(l-[0-9a-f]*\).*/\1/p')
bash "$SCRIPT_DIR/learning.sh" reject "$ID" "setup smoke test" >/dev/null && ok "learning.sh add/reject works ($ID)"
bash "$SCRIPT_DIR/log-run.sh" setup success "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "setup.sh ran" && ok "run log written: $RUNS_FILE"
echo "done. Next: open ~/.claude/CLAUDE.md and fill the marked sections, then read docs/playbook.md."

#!/bin/sh
# usage: newjob.sh <job-id> [feature text]   (run from the repo root, on main)
# Without feature text, claims the first "- [ ]" line of factory/backlog.md.
# Writes factory/jobs/<job-id>/job.json and creates the worktree ../<repo>-factory/<job-id>.
set -e
J=$1; FEAT=$2
[ -n "$J" ] || { echo "usage: newjob.sh <job-id> [feature]" >&2; exit 2; }
case "$J" in *[!A-Za-z0-9._-]*|.*) echo "job-id: letters, digits, . _ - only, no leading dot" >&2; exit 2;; esac
REPO=$(basename "$PWD"); WT="$(cd .. && pwd)/$REPO-factory/$J"
mkdir -p factory/jobs && mkdir "factory/jobs/$J"
python3 -I - "$J" "$WT" "$FEAT" <<'PY'
import sys,json,pathlib
j,wt,feat=sys.argv[1],sys.argv[2],sys.argv[3]
if not feat:
    b=pathlib.Path('factory/backlog.md'); s=b.read_text()
    open_items=[l for l in s.splitlines() if l.startswith('- [ ]')]
    if not open_items: sys.exit("backlog is empty")
    line=open_items[0]; feat=line[6:]
    b.write_text(s.replace(line,'- [x] '+feat+' → '+j,1))
json.dump({"id":j,"feature":feat,"branch":"factory/"+j,"worktree":wt,"stage":"spec","round":0,
 "reviews":{k:"pending" for k in ["security","ux","ui","code"]}},open(f'factory/jobs/{j}/job.json','w'))
print(feat)
PY
git worktree add -q -b "factory/$J" "$WT" main
echo "worktree: $WT"

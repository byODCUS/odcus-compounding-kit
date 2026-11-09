---
description: Show the state of the compounding loops: open learnings, due follow-ups, last job runs, newest review report.
---
Run these and summarise in at most ten lines (counts first, then the items that need the user):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/learning.sh" list
bash "${CLAUDE_PLUGIN_ROOT}/scripts/followup.sh" due
tail -n 10 "${COMPOUNDING_HOME:-$HOME/.compounding}/logs/runs.jsonl"
ls -t "${COMPOUNDING_HOME:-$HOME/.compounding}/reports" | head -n 3
```

Failed or partial runs come first. Then due follow-ups. Then the number of open learnings and the newest report path. No advice unless something failed.

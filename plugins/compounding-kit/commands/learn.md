---
description: Record a gap in a working instruction (skill, job, rule). Usage: /learn <target> "what was missing" "patch proposal"
---
Record a learning. Arguments: `$ARGUMENTS` (target first, then the gap, then an optional patch proposal).

Run, with every free-text argument in single quotes so backticks and `$(...)` inside it stay text:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/learning.sh" add <target> 'what was missing' 'patch proposal'
```

If the arguments are incomplete, ask for the missing part in one line. A learning is a gap in an instruction, not a fact (memory) and not a dated task (`/followup`). Confirm with the id the script prints, nothing else.

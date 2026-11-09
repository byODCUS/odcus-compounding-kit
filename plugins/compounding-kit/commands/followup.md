---
description: Follow-ups with a due date. Usage: /followup "text" YYYY-MM-DD | /followup due | /followup list | /followup done <id>
---
Manage follow-ups. Arguments: `$ARGUMENTS`.

- Text plus a date: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/followup.sh" add '<text>' <YYYY-MM-DD>` (single quotes: the text may contain backticks)
- `due`, `list` or `done <id>`: pass through to the same script.

Print the script output as is. Convert relative dates ("next Friday") to the absolute date before calling the script.

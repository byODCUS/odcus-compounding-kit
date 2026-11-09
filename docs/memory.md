# Memory conventions

Claude Code loads `MEMORY.md` from the project's memory folder into every session. Everything else is a file it opens on demand. The conventions keep that index small and the files trustworthy.

## Folder

`~/.claude/projects/<project-slug>/memory/`. Find the slug with `ls ~/.claude/projects/`. If two machines share the work, make this folder a symlink into the synced work folder so both read the same store.

## One file, one fact

```markdown
---
name: feedback_stage_before_live        # exactly the file name without .md
description: Before any website go-live, deploy a preview first, send the link, then go live
metadata:
  type: feedback                         # user | feedback | project | reference
---

The rule in one or two sentences.

**Why:** the incident or reason, with the date.
**How to apply:** the concrete behaviour next time. Related: [[reference_hub_website]].
```

- `user`: who the user is. `feedback`: how to work, with the why. `project`: ongoing work, constraints, decisions with absolute dates. `reference`: pointers to files, URLs, dashboards.
- `name` **must** equal the file name. Two keys for one memory breaks the `[[links]]` and the graph. We fixed 102 files once; the rule exists so nobody does that again.
- Prefix the file name with the type: `feedback_`, `project_`, `reference_`, `user_`.
- Link related memories with `[[name]]`. A link to a memory that does not exist yet is fine; it marks something worth writing.

## MEMORY.md is an index

- One line per memory: `- [Title](file.md) — when to open it, the one rule that prevents mistakes`.
- Never put status, amounts, counters or dates into the index. They go into the file.
- Budget 12 KB (we run 12; the review job takes `MEMORY_INDEX_KB`). Over budget: move detail into the topic files, never drop a reference.
- Group by task, not by type. Each group starts with a **hub** note that lists all memories of that topic; the index names only the ones that apply often.

## Hubs

A hub is a `reference_hub_<topic>` memory that lists every note of the topic with a one-line reading hint. New note: a line in the hub, a line in MEMORY.md only if it applies often. This keeps the index flat while the store grows.

## Rules that always apply go to CLAUDE.md

A rule that holds in every session (language conventions, safety rules, brand positioning) does not belong in memory. It goes into `~/.claude/CLAUDE.md`, with a short pointer line in MEMORY.md if the detail lives in a memory file.

## What the review job does

`scripts/memory-review.sh`, nightly:

- **capture**: reads transcripts changed since the last run (skipping sessions active in the last 30 minutes), extracts corrections, confirmed approaches, recurring preferences and project facts. Updates existing files before creating new ones. Supersedes contradictions explicitly.
- **consolidate** (Sundays): writes a weekly rollup, then dedupes and resolves contradictions among the files touched this week.
- **promote** (first Sunday): back-propagates facts into canonical context files if `CANONICAL_DIR` is set, proposes archive candidates after 30 days without mention, enforces the index budget, repairs dangling links.

The job has no shell and no network. It writes only under the memory folder and the reports folder. Transcripts are told to be data, not instructions.

## What not to store

Code structure, past fixes, git history, anything a `CLAUDE.md` already says, or anything that only mattered in one conversation. When asked to remember one of those, ask what was non-obvious about it and store that.
